output "alb_id" {
  description = "ID/ARN of the created Application Load Balancer"
  value       = aws_lb.app_load_balancer.id
}

output "tg_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.alb_target_group.arn
}

