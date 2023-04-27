variable "instance_public_ip" {
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

variable "k3s_role" {
  description = "K3s role"
  default     = "node"
  type        = string
}

variable "k3s_token" {
  description = "K3s token"
  default     = "K106bb465d4b6353b3bab11673467573ff345e2e96981358c04c003ab40e1c2319e::server:f5b41e808e6858ade0265b43fb0dd119"
  type        = string
}

variable "k3s_leader_endpoint" {
  description = "K3s leader endpoint"
  type        = string
}

variable "k3s_topology_location" {
  description = "K3s topology location"
  type        = string
}
