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
