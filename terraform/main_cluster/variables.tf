variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "host_port" {
  type = number
  default = 80
}

variable "container_port" {
  type = number
  default = 80
}

variable "tpl_path" {
  type = string
}

variable "app_name" {
  type = string
}

variable "account_id" {
  type = string
}

variable "aws_vpc_id" {
  type = string
}

variable "aws_subnet_cluster_ids" {
  type = list(string)
}

variable "aws_lb_arn" {
  type = string
}

variable "acm_arn" {
  type = string
}
