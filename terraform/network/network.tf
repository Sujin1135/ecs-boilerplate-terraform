resource "aws_vpc" "cluster_vpc" {
  tags = {
    Name = "ecs-vpc-${var.env_suffix}"
  }
  cidr_block = "10.30.0.0/16"
}

data "aws_availability_zones" "available" {

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.cluster_vpc.id
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.cluster_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "ecs-private-subnet-${var.env_suffix}"
  }
}

resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.cluster_vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.cluster_vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "ecs-public-subnet-${var.env_suffix}"
  }
}

resource "aws_internet_gateway" "cluster_igw" {
  vpc_id = aws_vpc.cluster_vpc.id

  tags = {
    Name = "ecs-igw-${var.env_suffix}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id          = aws_vpc.cluster_vpc.main_route_table_id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.cluster_igw.id
}

resource "aws_eip" "nat_gateway" {
  count       = var.az_count
  vpc         = true
  depends_on  = [aws_internet_gateway.cluster_igw]
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat_gateway.*.id, count.index)

  tags = {
    Name = "NAT gw ${var.env_suffix}"
  }
}

resource "aws_route_table" "private_route" {
  count  = var.az_count
  vpc_id = aws_vpc.cluster_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }

  tags = {
    Name = "private-route-table-${var.env_suffix}"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster_igw.id
  }

  tags = {
    Name = "ecs-route-table-${var.env_suffix}"
  }
}

resource "aws_route_table_association" "to-public" {
  count = length(aws_subnet.public)
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public_route.*.id, count.index)
}

resource "aws_route_table_association" "to-private" {
  count = length(aws_subnet.private)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
}
