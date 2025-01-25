variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "env" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "West US 2"
}

variable "chris_ip" {
  type = string
}

variable "victor_ip" {
  type = string
}

variable "subscription_id" {
  type = string
}

locals {
  location_prefix = lower(substr(var.location, 0, 3))
  prefix          = "${var.env}-${local.location_prefix}-example"
}
