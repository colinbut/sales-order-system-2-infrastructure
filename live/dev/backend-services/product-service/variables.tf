variable "ami" {
    type        = string
    description = "The AMI id for the EC2 instance"
}

variable "key_pair" {
    type        = string
    description = "The name of the key pair for ssh onto"
}

variable "server_name" {
    type        = string
    description = "The name of the server (for tagging use i.e. Name)"
}

variable "http_port" {
    type        = number
    description = "The port of the microservice to run"
}

variable "environment" {
    type         = string
    description  = "The name of the environment (for info purposes)"
}