locals {
  team        = var.team_name
  stack       = "spring-mcp-server-demo"
  environment = var.environment
  name        = "${local.team}-${local.environment}-${local.stack}"
  tags = {
    team        = local.team
    stack       = local.stack
    environment = local.environment
  }

  mcp_svc = "${local.team}-${local.environment}-mcp-svc"

  tasks_iam_role_statements = {
    execute_allow = {
      actions   = ["ecs:ExecuteCommand"]
      effect    = "Allow"
      resources = [module.ecs.cluster_arn]
    }
  }
  task_exec_iam_statements = {
    create_log_group_for_service_connect = {
      actions   = ["logs:CreateLogGroup"]
      effect    = "Allow"
      resources = ["*"]
    }
  }
}

data "aws_availability_zones" "azs" {}
