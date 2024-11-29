provider "aws" {
  region = var.default_region
}

module "backup_vault" {
  source      = "./modules/backup_vault"
  name        = "my-backup-vault"
  kms_key_arn = var.kms_key_arn
}

resource "aws_backup_plan" "backup_plan" {
  name = "daily-backup-plan"

  rule {
    rule_name         = "daily-backup-rule"
    target_vault_name = module.backup_vault.vault_name
    schedule          = "cron(0 12 * * ? *)"  

    lifecycle {
      cold_storage_after = 7
      delete_after       = var.retention_days
    }

    dynamic "copy_action" {
      for_each = var.regions
      content {
        destination_backup_vault_arn = module.backup_vault.vault_arn
        lifecycle {
          delete_after = var.retention_days
        }
      }
    }
  }
}

resource "aws_backup_selection" "backup_selection" {
  name           = "resource-selection"
  backup_plan_id = aws_backup_plan.backup_plan.id
  iam_role_arn   = aws_iam_role.backup_role.arn

  resources = [
    "arn:aws:ec2:region:account-id:volume/*",
    "arn:aws:rds:region:account-id:db/*",
    "arn:aws:dynamodb:region:account-id:table/*"
  ]

  condition {
    condition_type = "StringEquals"
    key            = "tag:ToBackup"
    value          = var.tags["ToBackup"]
  }
}

resource "aws_iam_role" "backup_role" {
  name = "backup_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        },
        Action   = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "backup_policy"

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect   = "Allow",
          Action   = "backup:*",
          Resource = "*"
        }
      ]
    })
  }
}
