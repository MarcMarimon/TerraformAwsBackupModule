variable "default_region" {
  description = "Región por defecto"
  type        = string
  default     = "us-east-1"
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para cifrado de backups"
  type        = string
}

variable "retention_days" {
  description = "Número de días de retención para los backups"
  type        = number
  default     = 30
}

variable "regions" {
  description = "Regiones para los respaldos cruzados"
  type        = list(string)
  default     = ["us-west-1", "us-east-2"]
}

variable "tags" {
  description = "Etiquetas de los recursos a respaldar"
  type        = map(string)
  default     = {
    ToBackup = "true"
    Owner    = "owner@eulerhermes.com"
  }
}
