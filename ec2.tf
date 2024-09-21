resource "aws_instance" "public_instance" {
  ami           = "ami-0e86e20dae9224db8" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "public-ec2"
  }

  security_groups = [aws_security_group.public_security_group.id]
}
resource "aws_instance" "private_instance" {
  ami = "ami-0e86e20dae9224db8" 
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet_1.id
  tags = {
    Name = "private-ec2"
  }
}
