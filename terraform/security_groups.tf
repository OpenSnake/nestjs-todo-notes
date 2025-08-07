resource "aws_security_group" "sg-alb" {
  name = "tf-sg-alb"
  description = "Security group for public subnets with ALB"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-sg-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb-http" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb-https" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb-to-ecs" {
  security_group_id = aws_security_group.sg-alb.id
  referenced_security_group_id = aws_security_group.sg-ecs.id
  from_port = var.app_port
  to_port = var.app_port
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb-to-all" {
  security_group_id = aws_security_group.sg-alb.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "sg-ecs" {
  name = "tf-sg-ecs"
  description = "Security group for private subnets with ECS"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-sg-ecs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs-from-alb" {
  security_group_id = aws_security_group.sg-ecs.id
  referenced_security_group_id = aws_security_group.sg-alb.id
  from_port = var.app_port
  to_port = var.app_port
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs-to-db" {
  security_group_id = aws_security_group.sg-ecs.id
  referenced_security_group_id = aws_security_group.sg-documentdb.id
  from_port = var.db_port
  to_port = var.db_port
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs-to-all" {
  security_group_id = aws_security_group.sg-ecs.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "sg-documentdb" {
  name = "tf-sg-document-db"
  description = "Security group for private subnets with DocumentDB"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-sg-documentdb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db-from-ecs" {
  security_group_id = aws_security_group.sg-documentdb.id
  referenced_security_group_id = aws_security_group.sg-ecs.id
  from_port = var.db_port
  to_port = var.db_port
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db-to-vpc" {
  security_group_id = aws_security_group.sg-documentdb.id
  cidr_ipv4 = "10.10.0.0/16"
  ip_protocol = "-1"
}

resource "aws_security_group" "sg-endpoints" {
  name = "tf-sg-endpoint-ecr"
  description = "Security group for VPC Endpoints"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-sg-endpoint-ecr"
  }
}

resource "aws_vpc_security_group_ingress_rule" "endpoints-from-ecs" {
  security_group_id = aws_security_group.sg-endpoints.id
  referenced_security_group_id = aws_security_group.sg-ecs.id
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "endpoints-to-all" {
  security_group_id = aws_security_group.sg-endpoints.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}