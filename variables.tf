variable "app_name" {
  description = "Unique name for the Container App and its associated resources."
  type        = string
}

variable "container_image" {
  description = "Full URL of the Docker image in ACR (ej: miacr.azurecr.io/miapi:v1)."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the app will be deployed."
  type        = string
}

variable "container_app_environment_id" {
  description = "ID of the shared Azure Container Apps Environment."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the API container."
  type        = number
  default     = 8000
}

variable "health_check_path" {
  description = "Endpoint for the health probe."
  type        = string
  default     = "/health"
}

variable "cpu" {
  description = "CPU allocated to the container (e.g., 0.25)."
  type        = number
  default     = 0.25
}

variable "memory" {
  description = "Memory allocated to the container (e.g., '0.5Gi')."
  type        = string
  default     = "0.5Gi"
}

variable "container_name" {
  description = "Unique name for the Blob Storage Container"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the existing Storage Account where the container will be created"
  type        = string
}
