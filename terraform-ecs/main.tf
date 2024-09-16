provider "aws" {
  region = "eu-central-1"
}

resource "aws_ecs_cluster" "feedback-app-cluster" {
  name = "feedback-app-cluster"
}

resource "aws_ecs_task_definition" "feedback-app-task-definition" {
  family = "feedback-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = <<DEFINITION
    [
        {
            "name": "postgres-db",
            "image": "postgres:latest",
            "portMappings": [
                {
                    "name": "postgres-db-5432-tcp",
                    "containerPort": 5432,
                    "hostPort": 5432,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [
                {
                    "name": "POSTGRES_PASSWORD",
                    "value": "password"
                },
                {
                    "name": "POSTGRES_DB",
                    "value": "feedbackdb"
                }
            ],
            "healthCheck": {
                "command": [
                    "CMD-SHELL",
                    "pg_isready -U postgres"
                ],
                "interval": 5,
                "timeout": 5,
                "retries": 5,
                "startPeriod": 5
            }
        },
        {
            "name": "feedback-app",
            "image": "galaataman/feedback-app:latest",
            "portMappings": [
                {
                    "name": "feedback-app-3000-tcp",
                    "containerPort": 3000,
                    "hostPort": 3000,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [
                {
                    "name": "DB_NAME",
                    "value": "feedbackdb"
                },
                {
                    "name": "DB_HOST",
                    "value": "localhost"
                },
                {
                    "name": "DB_PORT",
                    "value": "5432"
                },
                {
                    "name": "DB_USER",
                    "value": "postgres"
                },
                {
                    "name": "DB_PASSWORD",
                    "value": "password"
                }
            ],
            "dependsOn": [
                {
                    "containerName": "postgres-db",
                    "condition": "HEALTHY"
                }
            ]
        }
    ]
  DEFINITION
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

}

resource "aws_ecs_service" "feedback-app-service" {
  name = "feedback-app-service"
  cluster = aws_ecs_cluster.feedback-app-cluster.id
  task_definition = aws_ecs_task_definition.feedback-app-task-definition.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [ var.public_subnet_id ]
    security_groups = [ var.security_group_id ]
    assign_public_ip = true
  }
}