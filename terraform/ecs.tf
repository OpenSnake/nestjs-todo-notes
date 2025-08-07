resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "tf-ecsTaskExecRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_exec_attach" {
  name = "tf-ecsTaskExecPolicy"
  roles = [aws_iam_role.ecs_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.service_name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "task" {
  family = "tf-app-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.task_cpu
  memory = var.task_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "app"
      image = var.container_image
      portMappings = [{ containerPort = var.app_port, protocol = "tcp" }]
      environment = [
        {
          name = "DATABASE_URI"
          value = "mongodb://${var.db_username}:${var.db_password}@${aws_docdb_cluster.db-cluster.endpoint}:${var.db_port}/${var.db_name}?ssl=true&tlsInsecure=true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.ecs.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {
  name = var.service_name
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = var.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.subnet-private-1.id,
      aws_subnet.subnet-private-2.id,
    ]
    security_groups = [aws_security_group.sg-ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    container_name = "app"
    container_port = var.app_port
  }

  depends_on = [
    aws_lb_listener.alb-listener-http,
    aws_lb_listener.alb-listener-https,
  ]
}