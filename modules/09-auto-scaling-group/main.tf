resource "aws_security_group" "asg_sg" {
  name   = "my-asg-security-group"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow HTTP traffic from the ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-instance-sg"
  }
}

resource "aws_launch_template" "default" {
  name          = var.name_prefix
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }

  user_data = base64encode(var.user_data)

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.asg_sg.id]
  }

  tags = {
    Name = "${var.name_prefix}-launch-template"
  }
}

resource "aws_autoscaling_group" "default" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = var.target_group_arns

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-instance"
    propagate_at_launch = true
  }
}
