variable "region"        { description = "AWS region"; type = string; default = "af-south-1" }
variable "name_prefix"   { description = "Resource name prefix"; type = string; default = "jeff-lab" }
variable "vpc_id"        { description = "VPC to deploy into"; type = string }
variable "admin_ip"      { description = "Admin public IP allowed on SSH (no /32)"; type = string }
variable "ami_id"        { description = "Ubuntu AMI for the region"; type = string }
variable "instance_type" { description = "Cheapest suitable size"; type = string; default = "t3.micro" }
variable "key_name"      { description = "Existing EC2 key pair name"; type = string }
