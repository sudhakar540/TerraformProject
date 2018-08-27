provider "aws" {
  access_key = "AKIAJQD6BFDN6TFFY25A"
  secret_key = "9IiWmRemiACYpSm7PUcnNrTjn8aMIBr9fccqdQrs"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}