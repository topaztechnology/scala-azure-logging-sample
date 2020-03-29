variable "instance-name" {
  type = string
  default = "azure-logging"
}

variable "location" {
  type = string
  default = "UK South"
}

# Must be alphanumeric
variable "acr-name" {
  type = string
  default = "azureloggingcr"
}

variable "image-name" {
  type = string
  default = "azure-logging"
}