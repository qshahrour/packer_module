# ==================================================
# Network Load Balancer:
#   * Balancer Name   =>  http_asg
#   * Target Group    =>  http_tgt
#   * Listener Name   =>  http_listener
# ==================================================
# Network Load Balancer  => http
resource "aws_lb" "http_asg" {
name                        = "${var.env}-internal-facing-nlb"
internal                    = true
load_balancer_type          = "network"
#subnet                      = ["${aws_subnet.public.*.id}"]
enable_deletion_protection  = true

  tags = "${
    map(
    "Name", "${var.env}-internal-facing-nlb"
    //"Role", "Network Load Balancer"
    )
  }"
}
# ==================================================
# Target Group => http
resource "aws_lb_target_group" "http_tgt" {
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main-vpc.id
}
# ==================================================
# Listener Resource =>  http
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.http_asg.id

  default_action {
    target_group_arn = aws_lb_target_group.http_tgt.id
    type             = "forward"
  }
}
# ==================================================
# End Point
resource "aws_vpc_endpoint_service" "http_asg" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.http_asg.arn]
}
# ==================================================
# End Service 
resource "aws_vpc_endpoint_service" "http_asg" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.http.arn]
}
