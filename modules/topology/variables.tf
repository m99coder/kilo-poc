variable "leader_public_ip" {
  description = "Target server"
}

variable "ssh_public_key_file" {
  description = "SSH public key file"
  default     = "~/.ssh/hetzner.pub"
  type        = string
}

variable "ssh_port" {
  description = "SSH port to be used to provision instances"
  default     = 22
  type        = number
}

variable "ssh_username" {
  description = "SSH user, used only in output"
  default     = "root"
  type        = string
}
