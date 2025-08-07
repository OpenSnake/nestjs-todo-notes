resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "tf-rtb-public"
  }
}

resource "aws_route_table_association" "rtb-public-association-1" {
  subnet_id = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.rtb-public.id
}

resource "aws_route_table_association" "rtb-public-association-2" {
  subnet_id = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.rtb-public.id
}

resource "aws_route_table" "rtb-private-ecs" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-rtb-private-ecs"
  }
}

resource "aws_route_table_association" "rtb-private-association-1" {
  subnet_id = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.rtb-private-ecs.id
}

resource "aws_route_table_association" "rtb-private-association-2" {
  subnet_id = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.rtb-private-ecs.id
}

resource "aws_route_table" "rtb-private-documentdb" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-rtb-private-documentdb"
  }
}

resource "aws_route_table_association" "rtb-private-association-3" {
  subnet_id = aws_subnet.subnet-private-3.id
  route_table_id = aws_route_table.rtb-private-documentdb.id
}

resource "aws_route_table_association" "rtb-private-association-4" {
  subnet_id = aws_subnet.subnet-private-4.id
  route_table_id = aws_route_table.rtb-private-documentdb.id
}