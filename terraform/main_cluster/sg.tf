resource "aws_security_group" "ecs_tasks" {
  vpc_id = var.aws_vpc_id
  name = "ecs-tasks-sg"

  ingress {
    from_port = var.host_port
    protocol  = "tcp"
    to_port   = var.container_port
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}