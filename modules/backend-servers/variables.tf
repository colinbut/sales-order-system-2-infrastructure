variable "ami" {
    type        = string
    description = "ami ID for the EC2 instance to be based on"
}

variable "instance_type" {
    type        = string
    description = "The type of the EC2 instance"
    default     = "t2.micro"
}

variable "key_pair" {
    type = string
    description = "The key pair name for allowing ssh onto"
}

variable "server_name" {
    type = string
    description = "The name of the server to tag with"
}

variable "enable_public_facing" {
    type        = bool
    description = "Should assign a public ip address to make it public facing or not"
    default     = false
}

variable "security_groups" {
    type        = list
    description = "Security Groups to associate with this EC2 instance"
}

variable "subnet_id" {
    type        = string
    description = "The subnet id to launch this EC2 instance in"
}