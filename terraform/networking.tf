module "spring_mcp_server_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.mcp_svc
  cidr = "10.0.0.0/16"
  tags = merge(local.tags, {
    Name = local.mcp_svc
  })

  azs = data.aws_availability_zones.azs.names

  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_tags = merge(local.tags, {
    Name = "${local.mcp_svc}-public"
    type = "public"
  })
  public_route_table_tags = merge(local.tags, {
    Name = "${local.mcp_svc}-public"
    type = "public"
  })

  private_subnets = [
    # Private subnets
    "10.0.108.0/23", "10.0.110.0/23", "10.0.112.0/23",
  ]
  private_subnet_tags = merge(local.tags, {
    Name = "${local.mcp_svc}-private"
    type = "private"
  })
  private_route_table_tags = merge(local.tags, {
    Name = "${local.mcp_svc}-private"
    type = "private"
  })

  enable_dns_hostnames = true

  # One NAT per Az
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}