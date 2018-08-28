provider "aws" {  
  region     = "${var.region}"
}

resource "aws_instance" "example" {
  ami           = "ami-f976839e"
  instance_type = "t2.micro"
  tags {
    Name = "Example"
  }
}
