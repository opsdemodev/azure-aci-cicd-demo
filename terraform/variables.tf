variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-azure-aci-cicd"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
  default     = "azureacicicd2026"
}
