resource "aws_vpc_endpoint" "endpoint-ecr-api" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.subnet-private-1.id,
    aws_subnet.subnet-private-2.id,
  ]
  security_group_ids = [aws_security_group.sg-endpoints.id]
  private_dns_enabled = true
  tags = {
    Name = "tf-endpoint-ecr-api"
  }
}

resource "aws_vpc_endpoint" "endpoint-ecr-dkr" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.subnet-private-1.id,
    aws_subnet.subnet-private-2.id,
  ]
  security_group_ids = [aws_security_group.sg-endpoints.id]
  private_dns_enabled = true
  tags = {
    Name = "tf-endpoint-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "endpoint-s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.rtb-private-ecs.id,
    aws_route_table.rtb-private-documentdb.id,
  ]
  tags = {
    Name = "tf-endpoint-s3"
  }
}

resource "aws_vpc_endpoint" "endpoint-cloudwatch-logs" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.subnet-private-1.id, aws_subnet.subnet-private-2.id]
  security_group_ids = [aws_security_group.sg-endpoints.id]
  private_dns_enabled = true
  tags = {
    Name = "tf-endpoint-cloudwatch-logs"
  }
}