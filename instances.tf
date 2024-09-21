# modules/instances.tf

# EC2 Instances
resource "aws_instance" "jenkins" {
  count         = 3 
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro" 
  subnet_id     = count.index < 2 ? var.public_subnets[0] : var.public_subnets[1] 
  security_groups = [var.security_group_ids.jenkins]

  tags = {
    Name = "Jenkins-${count.index + 1}"
  }
}

resource "aws_instance" "backend" {
  count         = 2
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro" 
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
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro" 
  subnet_id     = count.index == 0 ? var.private_subnets[0] : var.private_subnets[1] 
  security_groups = [var.security_group_ids.database]

  tags = {
    Name = "Database-${count.index + 1}"
  }
}

# Outputs
output "jenkins_public_ips" {
  value = aws_instance.jenkins.*.public_ip
}