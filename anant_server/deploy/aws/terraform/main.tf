# Terraform and AWS setup

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13"
    }
  }

  required_version = ">= 1.1.9"
}

provider "aws" {
  #   profile = "default"
  region = var.aws_region
}

output "api_url" {
  value = "https://api.xellara.com"
  description = "The URL of the API endpoint"
}

output "web_url" {
  value = "https://app.xellara.com"
  description = "The URL of the Web app"
}

output "insights_url" {
  value = "https://insights.xellara.com"
  description = "The URL of the Insights dashboard"
}
