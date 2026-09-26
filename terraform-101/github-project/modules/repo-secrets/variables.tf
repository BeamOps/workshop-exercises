variable "repository" {
  type        = string
  description = "Name of the repository to set the Actions secrets on."
}

variable "secrets" {
  type        = map(string)
  description = "Map of secret name => value to create as GitHub Actions secrets."
  sensitive   = true
}
