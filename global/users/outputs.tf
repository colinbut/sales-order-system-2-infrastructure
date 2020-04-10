output "usernames" {
    value = aws_iam_user.users[*]
}