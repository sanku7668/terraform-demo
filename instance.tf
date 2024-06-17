resource "aws_instance" "private_instance" {
  ami                         = "ami-00beae93a2d981137"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = true
  key_name                    = "win-webserver-keypair"
  security_groups             = [aws_security_group.vpc_sg.id]
  tags = {
    Name = "private-instance"
  }
}

resource "aws_instance" "public_instance" {
  ami                         = "ami-00beae93a2d981137"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id
  security_groups             = [aws_security_group.vpc_sg.id]
  key_name                    = "win-webserver-keypair"
  tags = {
    Name = "public-instance"
  }
}