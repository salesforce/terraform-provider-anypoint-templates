variable "cplane" {
  type        = string
  default     = "us"
  description = "Anypoint control plane"
}

variable "username" {
  type        = string
  default     = ""
  description = "the username of the anypoint user"
}

variable "password" {
  type        = string
  default     = ""
  description = "the password of the anypoint user"
}

variable "client_id" {
  type        = string
  default     = ""
  description = "the client_id of the anypoint connected app"
}

variable "client_secret" {
  type        = string
  default     = ""
  description = "the client_secret of the anypoint connected app"
}

variable "access_token" {
  type        = string
  default     = ""
  description = "the client_secret of the anypoint connected app"
}

variable "root_org" {
  type        = string
  default     = ""
  description = "the anypoint root organization id"
}

variable "root_team" {
  type        = string
  default     = ""
  description = "your organization's root team id"
}