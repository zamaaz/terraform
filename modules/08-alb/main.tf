provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "alb_sg" {
  name   = "my-alb-security-group"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_lb" "default" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "default" {
  name     = "my-app-targets"
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"

  health_check {
    path = var.health_check_path
  }
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_target_group_attachment" "default" {
  count = length(var.target_ec2_instance_ids)

  target_group_arn = aws_lb_target_group.default.arn
  target_id        = var.target_ec2_instance_ids[count.index]
  port             = var.target_group_port
}
