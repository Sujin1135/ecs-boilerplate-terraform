variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "account_id" {
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "bucket_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "elb_account_id" {
  type = string
  default = "600734575887"
}

variable "domain" {
  type = string
}

variable "env_suffix" {
  type = string
  default = ""
}

variable "tpl_path" {
  type = string
}

variable "container_port" {
  type = number
  default = 80
}

variable "host_port" {
  type = number
  default = 80
}

variable "az_count" {
  type    = number
  default = 4
}

variable "scaling_max_capacity" {
  type = number
  default = 3
}

variable "scaling_min_capacity" {
  type = number
  default = 1
}

variable "cpu_or_memory_limit" {
  type = number
  default = 70
}
