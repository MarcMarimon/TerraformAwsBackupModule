variable "name" {
  description = "Nombre del Backup Vault"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para cifrar los backups"
  type        = string
}
