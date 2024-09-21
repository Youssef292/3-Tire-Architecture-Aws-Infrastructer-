resource "aws_lb" "jenkins_alb" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "jenkins_tg" {
  name        = "jenkins-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/"  # Adjust if Jenkins health check path is different
  }
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "jenkins" {
  count            = var.jenkins_instances
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = module.instances.jenkins_instances[count.index].id
  port             = 8080
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow inbound HTTP"
  vpc_id      = variable.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Outputs
output "alb_dns_name" {
  value = aws_lb.jenkins_alb.dns_name
}