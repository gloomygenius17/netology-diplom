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

variable "subnets" {
  description = "Subnets configuration"
  type = map(object({
    cidr = string
    zone = string
  }))
  default = {
    "public-a" = {
      cidr = "10.10.0.0/24"
      zone = "ru-central1-a"
    }
    "private-a" = {
      cidr = "10.10.1.0/24"
      zone = "ru-central1-a"
    }
    "private-b" = {
      cidr = "10.10.2.0/24"
      zone = "ru-central1-b"
    }
  }
}
