variable "ami" {
    type        = string
    description = "AMI id of EC2 instance"
}

variable "key_pair" {
    type        = string
    description = "The name of key pair to ssh onto the EC2 instance"
}

variable "server_name" {
    type        = string
    description = "The name of the server to give (for tagging purposes)"
}

variable "environment" {
    type        = string
    description = "The environment to provision into (for info purposes)"
}

variable "mongo_port" {
    type        = number
    description = "The port that this ec2 instance exports"
    default     = 27017
}