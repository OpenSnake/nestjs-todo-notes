resource "aws_docdb_subnet_group" "db-subnet-group" {
  name = "db-subnet-group"
  subnet_ids = [
    aws_subnet.subnet-private-3.id,
    aws_subnet.subnet-private-4.id,
  ]
  tags = {
    Name = "tf-db-subnet-group"
  }
}

resource "aws_docdb_cluster" "db-cluster" {
  cluster_identifier = "docdb-cluster"
  engine = "docdb"
  master_username = var.db_username
  master_password = var.db_password
  db_subnet_group_name = aws_docdb_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.sg-documentdb.id]
  skip_final_snapshot = true
}

resource "aws_docdb_cluster_instance" "db-instance" {
  count = 2
  identifier = "docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.db-cluster.id
  instance_class = "db.t4g.medium"
  apply_immediately = true
}