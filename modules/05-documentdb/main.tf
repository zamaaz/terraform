provider "aws" {
  region = var.aws_region
}

resource "aws_docdb_subnet_group" "default" {
  name       = "my-docdb-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My docdb subnet group"
  }
}

resource "aws_security_group" "docdb_sg" {
  name   = "docdb-security-group"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow DocDB connections from within the VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docdb-sg"
  }
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier     = var.cluster_identifier
  master_username        = var.master_username
  master_password        = var.master_password
  db_subnet_group_name   = aws_docdb_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  skip_final_snapshot    = true
}

resource "aws_docdb_cluster_instance" "docdb_instances" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class
}
