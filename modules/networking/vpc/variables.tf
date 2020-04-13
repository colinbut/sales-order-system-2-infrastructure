variable "cidr_block" {
    type        = string
    description = "The CIDR block for VPC"
    default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type        = bool
    description = "Should we enable DNS hostnames for this VPC"
    default     = true
}

variable "resource_name" {
    type        = string
    description = "Name of this resource"
}