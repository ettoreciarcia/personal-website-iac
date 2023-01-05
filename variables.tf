variable "application_name" {
  type        = string
  description = "Name of the application"
}

variable "environment" {
  type        = string
  description = "Environment of the application dev/test/prod"
}

variable "region" {
  type = string
}