data "aws_ssm_parameter" "linuxAMI" {
  provider = aws.provider
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair
resource "aws_key_pair" "master-key" {
  provider   = aws.provider
  key_name   = "web_server_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web_server" {
  provider                    = aws.provider
  ami                         = data.aws_ssm_parameter.linuxAMI.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "apache-web-server"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd"
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd.service",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}