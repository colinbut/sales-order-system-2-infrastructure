variable "allocation_id" {
    type = string
    description = "The Elastic IP Address Id reference"
}

variable "subnet_id" {
    type        = string
    description = "The subnet to put this NAT Gateway into"
}

variable "depends" {
    type = list(any)
    description = "List of gateways (e.g. IGW) to depend on"
}