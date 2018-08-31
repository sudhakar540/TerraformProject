variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-2"
}

variable "aws_amis" {
  default = {
   # "us-east-1" = "ami-5f709f34"
    "us-west-2" = "ami-51537029"
  }
}

variable "key_name" {
  description = "Name of the SSH keypair to use in AWS."
}
variable "access_key" {
    default = "foo"
}
variable "secret_key" {
    default = "foo"
}
