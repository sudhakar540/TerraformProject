variable "stack_name"{
	description = "Name of the current Stack"
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
