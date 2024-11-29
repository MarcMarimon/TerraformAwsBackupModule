resource "aws_backup_vault" "vault" {
  name               = var.name
  encryption_key     = var.kms_key_arn  
  tags = {
    "Environment" = "Production"
  }
}


