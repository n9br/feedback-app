provider "aws" {
  region = "eu-central-1"
}

resource "aws_ecs_cluster" "hello-docker-app-cluster" {
  name = "hello-docker-app-cluster"
}

resource "aws_ecs_task_definition" "hello-docker-app-task-definition" {
  family = "hello-docker-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = <<DEFINITION
        [
            {
                "name": "hello-docker-app-container",
                "image": "galaataman/hello-docker-app",
                "portMappings": [
                    {
                        "containerPort": 3000,
                        "hostPort": 3000,
                        "protocol": "tcp"
                    }
                ],
                "essential": true
            }
        ]
  DEFINITION
  
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

}

resource "aws_ecs_service" "hello-docker-app-service" {
  name = "hello-docker-app-service"
  cluster = aws_ecs_cluster.hello-docker-app-cluster.id
  task_definition = aws_ecs_task_definition.hello-docker-app-task-definition.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [ var.public_subnet_id ]
    security_groups = [ var.security_group_id ]
    assign_public_ip = true
  }
}