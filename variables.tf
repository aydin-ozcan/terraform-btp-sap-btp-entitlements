variable "entitlements" {
  description = "Entitlements List"
  type        = map(list(string))
  default     = {}
  validation {
    condition = alltrue([
      for s, p in var.entitlements : length(p) == length(toset(p))
    ])
    error_message = "Each service inside 'entitlements' must have distinct plan names."
  }
}

variable "subaccount" {
  type = string
}
