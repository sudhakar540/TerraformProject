

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_availability_zones" "all" {}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "${var.stack_name}"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.instance.id}"]

# We run a remote provisioner on the instance after creating it.

# In this case, we just install nginx and start it. By default,
# this should be on port 80
  user_data = "${file("userdata.sh")}"

#  provisioner "remote-exec" {
#    inline = [
#      "sudo su","apt-get update&&apt-get -y install docker",
#    ]
#    connection {
#        user = "ubuntu"
#        type = "ssh"
#        private_key = "${file("")}"
#    }
#  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "as_grp" {
  name                 = "${var.stack_name}"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "${var.stack_name}-ec2"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  name = "${var.stack_name}-1"

  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "instance" {
  name = "${var.stack_name}-2"

  # Inbound HTTP from anywhere
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound traffic to Postgres Endpoint

    ingress {
    from_port   = 5432
    to_port     = 5432
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

  # aws_launch_configuration.launch_configuration in this module sets create_before_destroy to true, which means
  # everything it depends on, including this resource, must set it as well, or you'll get cyclic dependency errors
  # when you try to do a terraform destroy.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "example" {
  name = "${var.stack_name}"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}


# Postrgres Database Resource

resource "aws_db_instance" "pavan" {  
  allocated_storage        = 5   # GB
  engine                   = "postgres"
  engine_version           = "9.5.4"
  identifier               = "pavandb"
  instance_class           = "db.t2.micro"
  multi_az                 = false
  name                     = "pavandb"
  username                 = "${var.dbusername}"
  password                 = "${var.dbpassword}"
  port                     = 5432
  publicly_accessible      = true
  storage_type             = "gp2"
  skip_final_snapshot      = true
  vpc_security_group_ids   = ["${aws_security_group.instance.id}"]
}

output "endpoint" { value = "${aws_db_instance.pavan.endpoint}" }
output "username" { value = "${var.dbusername}" }
output "password" { value = "${var.dbpassword}" }
