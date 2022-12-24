resource "aws_lb" "staging" {
  name               = "alb"
  subnets            = aws_subnet.cluster[*].id
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  access_logs {
    bucket  = aws_s3_bucket.log_storage.id
    prefix  = "frontend-alb"
    enabled = true
  }

  tags = {
    Environment = "staging"
    Application = var.app_name
  }
}
