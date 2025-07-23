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
  desired_count        = 1

  enable_execute_command    = true
  tasks_iam_role_statements = local.tasks_iam_role_statements
  task_exec_iam_statements  = local.task_exec_iam_statements

  container_definitions = {
    demo_service = {
      cpu       = 256
      memory    = 512
      essential = true
      image     = var.docker_image
      port_mappings = [
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

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false
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
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_ipv4 = "0.0.0.0/0"
    }
  }

  tags = merge(local.tags, {
    Name = local.mcp_svc
  })
}