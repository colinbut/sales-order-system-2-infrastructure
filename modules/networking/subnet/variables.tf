variable "vpc_id" {
    type = number
    description = "The Id of the VPC"
}

variable "subnets" {
    type        = map(object({
        availability_zone = string
        public_ip         = bool
    }))
    description = "The subnets to create where key=resource_name and value=availability_zone"
}