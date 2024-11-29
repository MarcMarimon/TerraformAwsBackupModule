provider "aws" {
  region = var.default_region
  version = "~> 5.0" 
  access_key = "access-key"
  secret_key = "secret-key"
}