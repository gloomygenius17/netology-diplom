variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Folder ID"
  type        = string
}

variable "sa_key_file" {
  description = "Path to service account key JSON"
  type        = string
  default     = "~/key.json"
}

variable "ssh_public_key" {
  description = "SSH public key for VMs"
  type        = string
}
