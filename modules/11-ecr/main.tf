provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "default" {
  name = "${var.name_prefix}-ecr-repo"
}

resource "aws_ecs_cluster" "default" {
  name = "${var.name_prefix}-ecs-cluster"
}

resource "aws_iam_role" "ecs_role" {
  name = "${var.name_prefix}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name      = "ECS Task Role"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "default" {
  family                   = "${var.name_prefix}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}-container"
      image     = var.container_image
      cpu       = var.task_cpu
      memory    = var.task_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])

  tags = {
    Name = "${var.name_prefix}-task-definition"
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  name        = "${var.name_prefix}-ecs-tasks-sg"
  description = "Allow traffic from the ALB to the ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-ecs-tasks-sg"
  }
}


resource "aws_ecs_service" "default" {
  name            = "${var.name_prefix}-ecs-service"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.default.arn
  desired_count   = var.desired_tasks_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.name_prefix}-container"
    container_port   = var.container_port
  }
}
