variable "home_region" {
  type        = string
  description = "Central region which is used primarily or in which aws services are aggregated."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.home_region))
    error_message = "Invalid value for home_region. Region must be an AWS identifier such as: eu-central-1."
  }
  default = "ap-south-1"
}