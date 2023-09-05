resource "aws_launch_template" "js-ce-project-lt" {
  name          = "Project-launch-template"
  image_id      = var.newest_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  # user_data     = base64encode("user-data.tpl")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.allow_http, var.allow_https, var.allow_ssh]

  }
}

resource "aws_autoscaling_group" "auto_scaler" {
  count               = var.use_auto_scaling_group == true ? 1 : 0
  desired_capacity    = 3
  max_size            = 5
  min_size            = 2
  target_group_arns   = [var.tg_arn]
  health_check_type   = "ELB"
  vpc_zone_identifier = var.public_subnet_ids

tag {
    key                 = "Name"
    value               = "EC2-nginx ${count.index + 1}"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.js-ce-project-lt.id
    version = "$Latest"
  }
}
