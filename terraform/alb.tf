module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = local.mcp_svc

  load_balancer_type = "application"

  vpc_id  = module.spring_mcp_server_vpc.vpc_id
  subnets = module.spring_mcp_server_vpc.public_subnets

  # Security Group
  security_group_ingress_rules = {
    all_https = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "tcp"
      from_port   = 8080
      to_port     = 8080
      cidr_ipv4   = module.spring_mcp_server_vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex_https = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "ex_ecs"
      }
    }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = 8080
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/actuator/health"
        port                = "8080"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      # Theres nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

  tags = local.tags
}