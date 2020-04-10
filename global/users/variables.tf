variable "user_names" {
    description = "The list of usernames to create IAM users for"
    type        = list(string)
    default     = [ "dev_user", "test_user", "prod_user"]
}