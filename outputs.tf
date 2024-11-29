output "backup_vault_arn" {
  value = module.backup_vault.vault_arn
  description = "El ARN del Backup Vault"
}

output "backup_plan_id" {
  value = aws_backup_plan.backup_plan.id
  description = "El ID del plan de backup"
}
