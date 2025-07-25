terraform {
  backend "s3" {
    region       = "ap-southeast-1"
    bucket       = "vinod-terraform-test-bucket"
    key          = "merlion/dev/spring-mcp-server-demo"
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}