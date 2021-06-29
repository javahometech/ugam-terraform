resource "aws_key_pair" "web_api_key" {
  key_name   = "web-api-key"
  public_key = file("./scripts/web-api-key.pub")
}

# Create EBS volume
resource "aws_ebs_volume" "web" {
  availability_zone = module.myapp_vpc.azs[0]
  size              = 40
  tags = {
    Name = "web-api-ugam"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.web.id
  instance_id = aws_instance.web.id
}

resource "null_resource" "ebs_attach" {
  triggers = {
    size = aws_ebs_volume.web.size
  }
  connection {
    host        = aws_instance.web.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/kammana/ugam")
  }
  provisioner "remote-exec" {
    inline = [
      "touch hari.sh"
    ]
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-0ab4d1e9cf9a1215a"
  instance_type               = "t2.micro"
  subnet_id                   = module.myapp_vpc.pub_sub_ids[0]
  associate_public_ip_address = true
  availability_zone           = module.myapp_vpc.azs[0]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data                   = file("./scripts/apache.sh")
  key_name                    = aws_key_pair.web_api_key.key_name
  tags = {
    Name = "HelloWorld Ugam"
  }
}

# create security group for web application

resource "aws_security_group" "web_sg" {
  name        = "ugam_api_web_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.myapp_vpc.vpc_id

  dynamic "ingress" {
    for_each = var.web_sg_ingress
    content {
      description = "TLS from VPC"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ugam_api_web_sg"
  }
}