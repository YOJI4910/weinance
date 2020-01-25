variable "pgp_key" {
  default = "mQENBF4kOqMBCACu0pxOoMM/za6JyvH6DnSlFnDV9umqegWDsj1cg1xH45lWfFrwwBt1yXg8H+3wUKX58g3h9w+zo5H62uys//dw/VY1LJFIUERY2X7dPq6glrIGmqTZLifpOwZDQKP0/pb2RwOmAi4hWAXydiYujp78vCrkbLjT1vAh8s4O8r57zy32M+RnikdQf4afPEeEISHxiUiBV74eBAepyOjC83m+z/H99KO4y0vDo/YoTCYWMduZWG6U/PEyWSH6MnBGqAPeWRnN4VQymFMXv81LLfoumafjKr+LLW/2z5uXx8o7iYjBe/2Q3y15It6dW0V2W1gDyYpK7quT6A565paUNhd9ABEBAAG0JGFkbWluLXVzZXIgPGZtbi5vdXRsb29rQG91dGxvb2suY29tPokBVAQTAQgAPhYhBJ8Z5IqqBEy11RQ4KP40J8jD7B7YBQJeJDqjAhsDBQkDwmcABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEP40J8jD7B7Y4NYH/jmwU4yRIu/QORymAWKRVybx4L9hWchq30Jm+HOVLUuo/c3WiF9KYxFqL89O0LTDMXHpo80PIp/Zf75c2miIIWA4pk1pMInndsOu4HJP7yz6kV/hRnV46KszOuKvbIA8WErnb5NUESe4jjUO08oZBoi9fKqeoPibtjB5S86Hlp9i0YJo4YqEarAGDZgBgHeobmHobik5b84aiTRPCRqgGSQOSQyKr/+iwclJ/11gCHV1RQj/cGEEN/+8GzEKcDVWz9SroAWJAMsSE1AI7idiE4G5i0EjFiW+0ztn0F+l11YyUHQBhKGhdIGZAHfOHNW90V7/RjVBmiEub++ykNoUQVi5AQ0EXiQ6owEIANnF5WpZxa66kSnNzEqkmDe5w9VEYr0H2W2vFw0peVopsahxxiwgGQLgwOsamgnriIDPUiaqw+O/GWVxDXhz7U75r9GJXbRKH8WiP3CQLvuRaD9yyiUcHM5W61ZBhAt0iyNdKmw5JPQkGsivSn/ZT11SRsQg9RkSp9Ezwu0RRKlmdqLHHMOFHxC9mTahIjyUKrxVgnrv6Vb2LnNmNQV0KF0be7B7HOxbqsrO1PPQMxyMDwBitRpgk79c5PgO1z0nLhUdiwCIKTl7t8vVDPh9FD+fr1MS1I0E2UuWMS+tcjpaaJKXPE7M4+wQemO7G18YVAPWgqSaQkLx5n25xySfH3MAEQEAAYkBPAQYAQgAJhYhBJ8Z5IqqBEy11RQ4KP40J8jD7B7YBQJeJDqjAhsMBQkDwmcAAAoJEP40J8jD7B7YHBwH/1Z+TvvyUHyOB0aNI/5x7tuE3PEO93c8iEOISJn9pX68yWln83jaPSAZq/Yf33FVPTfR4q2UXp4CgMerco6cX80Mhj41HNVNQVYUqBpMEGx59Ks739Yzqf0mlnWXqXw4TXmWfETYC+CfIColQdIpLHBQ6SWvSpXcBkTyvRMoB5kdD+da8/kTpl29Tn62L1tA9BXmOjPbk6EbUAoyT7ksTDetd5Sp3Sq/8t+XLczFD3PvnpSBSh6NjFtWOiZVfApoZcIGBQjeUMzKwRvmqFHe4dPNJDME91uyH2ETxAst+pjuKGqVHdovrav6oM/7lvc/aCW3+XLugpdWkLv32OyEEik="
}
# 
# Adminユーザー
# 
resource "aws_iam_user" "admin-user" {
  name = "admin-user"
  path = "/"
  # IAMユーザを削除時にログインプロファイルやアクセスキーも一緒に削除
  force_destroy = true
}

resource "aws_iam_policy" "admin-policy" {
  name   = "AdministerPolicy"
  policy = file("./jsonfiles/admin_policy.json")
}

resource "aws_iam_user_policy_attachment" "admin-attach" {
  user       = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.admin-policy.arn
}

# Webコンソールログイン時のログイン情報
resource "aws_iam_user_login_profile" "admin_user_login_profile" {
  user                    = aws_iam_user.admin-user.name
  pgp_key                 = var.pgp_key
  password_reset_required = true
  password_length         = "20"
}

# AWS-CLIやAPIを利用する際に使う認証情報
resource "aws_iam_access_key" "admin_user_access_key" {
  user    = aws_iam_user.admin-user.name
  pgp_key = var.pgp_key
}

output "admin_user_iam_encrypted_secret" {
  value = aws_iam_access_key.admin_user_access_key.encrypted_secret
}
