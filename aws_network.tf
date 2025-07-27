# VPCの作成
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "172.17.0.0/16"
  enable_dns_hostnames = true
}

# Publicサブネット作成
resource "aws_subnet" "terraform_publicSubnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "172.17.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

# インターネットゲートウェイ作成

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
}

# Publicルートテーブルの作成

resource "aws_route_table" "terraform_public_rtb" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
}

# Publicサブネットにルートテーブルを紐づけ

resource "aws_route_table_association" "terraform_public_rtable_assoc" {
  subnet_id      = aws_subnet.terraform_publicSubnet.id
  route_table_id = aws_route_table.terraform_public_rtb.id
}


# セキュリティグループの作成
resource "aws_security_group" "terraform_sg" {
  name   = "terraform-security01"
  vpc_id = aws_vpc.terraform_vpc.id
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
}

