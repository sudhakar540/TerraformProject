provider "aws" { 
  region = "${var.aws_region}"
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file("/home/satheesh/terraform_ec2_key.pub")}"
}
resource "aws_eip" "default" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "eip_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  name = "test"
  ami           = "ami-f976839e"
  instance_type = "t2.micro"
  tags {
    Name = "eip-example"
  }
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.default.name}"]  
  user_data = "${file("userdata.sh")}"

}

