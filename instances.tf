# EC2 Instances
resource "aws_instance" "frontend" {
  count         = 2
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type 
  subnet_id     = count.index < 2 ? var.public_subnets[0] : var.public_subnets[1] 
  security_groups = [var.security_group_ids.jenkins]

  tags = {
    Name = "Jenkins-${count.index + 1}"
  }
}

resource "aws_instance" "backend" {
  count         = 2
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type 
  subnet_id     = count.index == 0 ? var.private_subnets[0] : var.private_subnets[1] 
  security_groups = [var.security_group_ids.backend]

  # Alternative for outbound internet access in the free tier
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y squid 
              sudo sed -i 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf
              sudo systemctl restart squid
              EOF

  tags = {
    Name = "Backend-${count.index + 1}"
  }
}

resource "aws_instance" "database" {
  count         = 2
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type 
  subnet_id     = count.index == 0 ? var.private_subnets[0] : var.private_subnets[1] 
  security_groups = [var.security_group_ids.database]

  tags = {
    Name = "Database-${count.index + 1}"
  }
}

resource "aws_instance" "ansible" {
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0]  
  security_groups = [var.security_group_ids.ansible]

  tags = {
    Name = "Ansible"
  }
}

