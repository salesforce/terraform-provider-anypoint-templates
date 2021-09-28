variable username {
  type        = string
  default     = "mike_cat"
  description = "the username of the anypoint user"
}

variable password {
  type        = string
  sensitive   = true
  description = "the password of the anypoint user"
}

variable owner_id {
  type        = string
  default     = "4ba9236f-fc97-49d1-b90c-c86dee1c6e13"
  description = "the id associated with mike-cat"
}

variable parent_org {
  type        = string
  default     = "aa1f55d6-213d-4f60-845c-207286484cd1"
  description = "The Parent Org"
}
