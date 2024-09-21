# Security Groups
resource "aws_security_group" "jenkins" {
  name        = "jenkins_sg"
  description = "Allow inbound SSH and HTTP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.jenkins_allowed_cidr_blocks
  }

  ingress {
    from_port   = 8080 
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.jenkins_allowed_cidr_blocks 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend" {
  name        = "backend_sg"
  description = "Allow inbound from Jenkins"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.jenkins.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database" {
  name        = "database_sg"
  description = "Allow inbound from backend"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 0 
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.backend.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# Outputs
output "security_group_ids" {
  value = {
    jenkins  = aws_security_group.jenkins.id
    backend  = aws_security_group.backend.id
    database = aws_security_group.database.id
  }
}