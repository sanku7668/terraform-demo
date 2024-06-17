
# resource "aws_s3_bucket" "datastore" {
#   bucket = "tflabbucket1606sj"
#   tags = {
#     "Name"      = "tflabbucket1606sj"
#     "Deparment" = "IT"
#   }
# }

resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    "Name"        = "TF-DEMO-VPC"
    "Description" = "this vpc is created from tf"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "Private-subnet"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
}
resource "aws_route_table" "public_sub_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
}

resource "aws_route_table" "private_sub_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

}
resource "aws_route_table_association" "public_rt_assocsn" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_sub_rt.id
}

resource "aws_route_table_association" "private_rt_assocsn" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_sub_rt.id
}
resource "aws_security_group" "vpc_sg" {
  name        = "vpc-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

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
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }
}