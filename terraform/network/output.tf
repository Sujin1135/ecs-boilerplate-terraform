output "aws_vpn_arn" {
  value = aws_vpc.cluster_vpc.arn
}

output "aws_vpn_id" {
  value = aws_vpc.cluster_vpc.id
}

output "aws_subnet_cluster_ids" {
  value = aws_subnet.cluster[*].id
}

output "aws_lb_arn" {
  value = aws_lb.staging.arn
}

output "acm-arn" {
  value = aws_acm_certificate.cert.arn
}
