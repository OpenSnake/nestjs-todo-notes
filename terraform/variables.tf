variable "aws_region" {
    default = "us-east-1"
}

variable "container_image" {
  description = "URI of image in ECR"
  type = string
}

variable "db_username" {
  description = "Username for DocumentDB"
  type = string
}

variable "db_password" {
  description = "Password for DocumentDB"
  type = string
  sensitive = true
}

variable "domain_name" {
  description = "Domain name for application"
  type = string
}

variable "db_name" {
  default = "tf-appdb"
}

variable "db_port" {
  default = 27017
}

variable "app_port" {
  default = 3000
}

variable "task_cpu" {
  default = 256
}

variable "task_memory" {
  default = 512
}

variable "desired_count" {
  default = 2
}

variable "cluster_name" {
  default = "tf-app-cluster"
}

variable "service_name" {
  default = "tf-app-service"
}