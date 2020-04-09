variable "ecr-repos-to-create" {
    description = "The container repositories to create"
    type        = list(string)
    default     = []
}