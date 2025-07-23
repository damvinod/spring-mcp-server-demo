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

  tasks_iam_role_statements = [
    {
      actions   = ["ecs:ExecuteCommand"]
      effect    = "Allow"
      resources = [module.ecs.cluster_arn]
    }
  ]
  task_exec_iam_statements = [
    {
      actions   = ["logs:CreateLogGroup"]
      effect    = "Allow"
      resources = ["*"]
    }
  ]
}

data "aws_availability_zones" "azs" {}
