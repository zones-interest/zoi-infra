# VPC
resource "aws_vpc" "zoi" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "zoi-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "zoi" {
  vpc_id = aws_vpc.zoi.id

  tags = {
    Name = "zoi-igw"
  }
}

# Public Subnets
resource "aws_subnet" "zoi_public_a" {
  vpc_id                  = aws_vpc.zoi.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "zoi-public-subnet-a"
  }
}

resource "aws_subnet" "zoi_public_b" {
  vpc_id                  = aws_vpc.zoi.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "zoi-public-subnet-b"
  }
}

# Route Table
resource "aws_route_table" "zoi_public" {
  vpc_id = aws_vpc.zoi.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zoi.id
  }

  tags = {
    Name = "zoi-public-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "zoi_public_a" {
  subnet_id      = aws_subnet.zoi_public_a.id
  route_table_id = aws_route_table.zoi_public.id
}

resource "aws_route_table_association" "zoi_public_b" {
  subnet_id      = aws_subnet.zoi_public_b.id
  route_table_id = aws_route_table.zoi_public.id
}

# Security Group for ALB
resource "aws_security_group" "zoi_alb" {
  name_prefix = "zoi-alb-"
  vpc_id      = aws_vpc.zoi.id

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

  tags = {
    Name = "zoi-alb-sg"
  }
}

# Security Group for ECS Tasks
resource "aws_security_group" "zoi_ecs" {
  name_prefix = "zoi-ecs-"
  vpc_id      = aws_vpc.zoi.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.zoi_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "zoi-ecs-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "zoi" {
  name               = "zoi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.zoi_alb.id]
  subnets            = [aws_subnet.zoi_public_a.id, aws_subnet.zoi_public_b.id]

  tags = {
    Name = "zoi-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "zoi" {
  name        = "zoi-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.zoi.id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/api/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "zoi-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "zoi" {
  load_balancer_arn = aws_lb.zoi.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.zoi.arn
  }
}

# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "zoi_ecs" {
  name              = "/ecs/zoi-app"
  retention_in_days = 7

  tags = {
    Name = "zoi-ecs-logs"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "zoi" {
  name = "zoi-cluster"

  tags = {
    Name = "zoi-cluster"
  }
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "zoi_ecs_task" {
  name = "zoi-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "zoi_ecs_execution" {
  name = "zoi-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "zoi_ecs_execution" {
  role       = aws_iam_role.zoi_ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch logging policy for ECS tasks
resource "aws_iam_role_policy" "zoi_ecs_logging" {
  name = "zoi-ecs-logging-policy"
  role = aws_iam_role.zoi_ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "zoi" {
  family                   = "zoi-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.zoi_ecs_execution.arn
  task_role_arn           = aws_iam_role.zoi_ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "zoi-app"
      image = "360691803169.dkr.ecr.eu-west-2.amazonaws.com/zoi-frontend:latest"
      
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "NEXT_PUBLIC_API_URL"
          value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.eu-west-2.amazonaws.com/dev"
        },
        {
          name  = "NEXTAUTH_SECRET"
          value = var.nextauth_secret
        },
        {
          name  = "NEXTAUTH_URL"
          value = "http://${aws_lb.zoi.dns_name}"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.zoi_ecs.name
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
      essential = true
    }
  ])

  tags = {
    Name = "zoi-app-task"
  }
}

# ECS Service
resource "aws_ecs_service" "zoi" {
  name            = "zoi-service"
  cluster         = aws_ecs_cluster.zoi.id
  task_definition = aws_ecs_task_definition.zoi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.zoi_public_a.id, aws_subnet.zoi_public_b.id]
    security_groups  = [aws_security_group.zoi_ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.zoi.arn
    container_name   = "zoi-app"
    container_port   = 3000
  }

  health_check_grace_period_seconds = 60

  depends_on = [aws_lb_listener.zoi]

  tags = {
    Name = "zoi-service"
  }
}