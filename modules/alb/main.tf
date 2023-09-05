resource "aws_lb" "app_load_balancer" {
  name               = "js-ce-project-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.allow_http, var.allow_https]

  tags = {
    Name = "App Load Balancer"
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "js-ce-project-alb-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

# resource "aws_lb_target_group_attachment" "tg_attachment" {
#   count = length(var.instance_ids)
#   target_group_arn = aws_lb_target_group.alb_target_group.arn
#   target_id        = var.instance_ids[count.index]
#   port             = 80
# }

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}