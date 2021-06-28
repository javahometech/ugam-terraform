resource "aws_instance" "web" {
  ami                    = var.web_amis[var.region]
  instance_type          = "t2.micro"
  key_name               = "ugam-tf-demo"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Provisioners Demo"
  }
  provisioner "file" {
    source      = "templates/ugam-api-iam.json"
    destination = "/home/ec2-user/ugam-api-iam.json"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/Users/kammana/Downloads/ugam-tf-demo.pem")
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-bad845d1"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_ugam"
  }
}