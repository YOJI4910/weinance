resource "aws_lb_target_group" "http" {
  name     = "sample-http"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 30
    path                = "/health_check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  depends_on = [aws_lb.lb]
}