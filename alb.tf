resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf_vpc.id
}
resource "aws_lb_target_group_attachment" "private_attach" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.private_instance.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "public_attach" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.public_instance.id
  port             = 80
}
resource "aws_lb" "alb_lb" {
  name               = "alb-lb"
  internal           = false
  load_balancer_type = "application"
  #   vpc_id = aws_vpc.tf_vpc.id
  security_groups = [aws_security_group.vpc_sg.id]
  subnets         = [aws_subnet.private_subnet.id, aws_subnet.public_subnet.id]
}
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

