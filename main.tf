provider "aws" {    
  region = "${var.aws_region}"
}
resource "aws_key_pair" "terraform_ec2_key" {
  key_name = "terraform_ec2_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJbNaKbbeZSjdHwfQRkKoL7ZToYyKxF7v7TQx+3KBK3gBGxw7NWzwDs/nWVOWIoKwwhalCjPWiSSy6oGSuPQNXXjLcm5mk9z7fclvaKTji1HmpmJ4iXqgXJ25I1CLf29KtPSA5/+MspYL5OgqRbv3gx9fP/DFCuQRnJ2HOW7P75dE5HXqENG3q52m9NdPXx5M1KnnMwg8XN/KAmtDRLnhtDLZwSheqyx3qnQaQemuvvxfKw+EAViDWoy9j8uDdkYG9eFCMFvNGdwsncXsrVo0m80S+Tmoq9Tzi1NX2oJ3TrLsSMaeje5iVNShraIgGS4lcgVYPmaDw9omeRsy5G7Zb satheesh@satheesh-VirtualBox"
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
  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair you've created and downloaded
  # from the AWS console.
  #
  # https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:
  #
  key_name = "${aws_key_pair.terraform_ec2_key.key_name}"

  # Our Security group to allow HTTP and SSH access
  security_groups = ["${aws_security_group.default.name}"]

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  user_data = "${file("userdata.sh")}"

  #Instance tags
  tags {
    Name = "eip-example"
  }
}

