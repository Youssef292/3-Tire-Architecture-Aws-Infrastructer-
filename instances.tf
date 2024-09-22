# Frontend EC2 Instances (Public)
resource "aws_instance" "frontend" {
  count         = 2
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type 
  subnet_id     = count.index < 2 ? var.public_subnets[0] : var.public_subnets[1]
  security_groups = [var.security_group_ids.jenkins]
  key_name      = "your-key-name"  # Directly specify the SSH key name

  tags = {
    Name = "Jenkins-${count.index + 1}"
  }
}

# Backend EC2 Instances (Private)
resource "aws_instance" "backend" {
  count         = 2
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type 
  subnet_id     = count.index == 0 ? var.private_subnets[0] : var.private_subnets[1]
  security_groups = [var.security_group_ids.backend]
  key_name      = "your-key-name"  # Directly specify the SSH key name

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

# Database EC2 Instances (Private)
resource "aws_instance" "database" {
  count         = 2
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type 
  subnet_id     = count.index == 0 ? var.private_subnets[0] : var.private_subnets[1]
  security_groups = [var.security_group_ids.database]
  key_name      = "your-key-name"  # Directly specify the SSH key name

  tags = {
    Name = "Database-${count.index + 1}"
  }
}

# Ansible Control Node EC2 (Public)
resource "aws_instance" "ansible" {
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0]
  security_groups = [var.security_group_ids.ansible]
  key_name      = "your-key-name"  

  tags = {
    Name = "Ansible"
  }
}

# NAT Gateway EC2 Instance (Public)
resource "aws_instance" "nat_gateway" {
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0]  
  security_groups = ["sg-nat-security-group-id"]  
  key_name      = "your-key-name"  

  user_data = <<-EOF
              #!/bin/bash
              sudo sysctl -w net.ipv4.ip_forward=1
              sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              EOF

  tags = {
    Name = "NAT-Gateway"
  }
}

# Route Table for Private Subnet to NAT Gateway
resource "aws_route" "private_to_nat" {
  route_table_id         = "rtb-xxxxxxxxxx" 
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_instance.nat_gateway.id  
}
