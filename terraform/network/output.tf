output "aws_vpn_arn" {
  value = aws_vpc.cluster_vpc.arn
}

output "aws_vpn_id" {
  value = aws_vpc.cluster_vpc.id
}

output "aws_subnet_public_ids" {
  value = aws_subnet.public[*].id
}

output "aws_lb_arn" {
  value = aws_alb.staging.arn
}

output "acm-arn" {
  value = aws_acm_certificate.cert.arn
}

output "aws_ecs_cluster_arn" {
  value = aws_ecs_cluster.staging.arn
}

output "container_definitions" {
  value = aws_ecs_task_definition.service.container_definitions
}
