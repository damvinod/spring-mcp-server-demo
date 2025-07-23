module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = local.name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  default_capacity_provider_strategy = {
    FARGATE_SPOT = {
      weight = 100
    }
  }

  tags = merge(local.tags, {
    Name = local.name
  })
}

module "mcp_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  cpu    = 256
  memory = 512

  name        = local.mcp_svc
  cluster_arn = module.ecs.cluster_arn

  assign_public_ip     = true
  autoscaling_policies = {}
  enable_autoscaling   = false
  desired_count        = 1

  enable_execute_command    = true
  tasks_iam_role_statements = local.tasks_iam_role_statements
  task_exec_iam_statements  = local.task_exec_iam_statements

  container_definitions = {
    mcp_server = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = var.docker_image
      portMappings = [
        {
          name          = "port-8080"
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "ENVIRONMENT"
          value = var.environment
        }
      ]

      healthCheck = {
        command      = ["CMD-SHELL", "curl -f http://localhost:8080/actuator/health || exit 1"]
        start_period = 10
      }

      # Example image used requires access to write to root filesystem
      readonlyRootFilesystem = false
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name   = "mcp_server"
      container_port   = 8080
    }
  }

  subnet_ids = module.spring_mcp_server_vpc.private_subnets

  security_group_ingress_rules = {
    ingress_port_8080 = {
      type        = "ingress"
      from_port   = 8080
      to_port     = 8080
      protocol    = "TCP"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow traffic on ingress 8080"
    }
  }

  security_group_egress_rules = {
    egress_all = {
      type      = "egress"
      from_port = 443
      to_port   = 443
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
    }
  }

  tags = merge(local.tags, {
    Name = local.mcp_svc
  })
}