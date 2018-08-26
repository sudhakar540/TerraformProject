variable "stack_name"{
	description = "Name of the current Stack"
}

variable "access_key" {
	description = "The AWS access key."
}
variable "secret_key" {
	description = "The AWS secret key."
}
variable "key_name" {
	description = "The AWS keypair name to access your EC2 Instances."
}
variable "region" {
	description = "The AWS region."
}
variable "server_port" {
	description = "The Server port to access web page."
}
variable "min_size" {
	description = "Minimum size of the AWS autoscaling group."
}
variable "max_size" {
	description = "Minimum size of the AWS autoscaling group."
}

variable "dbusername" {
	description = "Username of the AWS RDS instance"
}
variable "dbpassword"{
	description = "Password of the AWS RDS instance"
}

