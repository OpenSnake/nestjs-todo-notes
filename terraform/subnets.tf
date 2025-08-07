resource "aws_subnet" "subnet-public-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.0.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "tf-subnet-public-1"
  }
}

resource "aws_subnet" "subnet-public-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "tf-subnet-public-2"
  }
}

resource "aws_subnet" "subnet-private-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "tf-subnet-private-1"
  }
}

resource "aws_subnet" "subnet-private-2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "tf-subnet-private-2"
  }
}

resource "aws_subnet" "subnet-private-3" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "tf-subnet-private-3"
  }
}

resource "aws_subnet" "subnet-private-4" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "tf-subnet-private-4"
  }
}