resource "aws_lb" "lb" {
  name               = "sample-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id,
  ]

  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
  ]
}