# Create a Launch Configuration for ASG
resource "aws_launch_configuration" "my-test-launch-config" {
  image_id        = var.ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my-asg-sg.id]

  user_data = filebase64("userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
}

#You must specify either launch_configuration, launch_template, or mixed_instances_policy when using aws_autoscaling_group.
resource "aws_launch_template" "test-launch-template" {
  name = "test-launch-template"
  image_id = var.ami
  instance_type = "t2.micro"
  user_data = filebase64("userdata.sh")

  vpc_security_group_ids = [aws_security_group.my-asg-sg.id]

    lifecycle {
      create_before_destroy = true
  }
}

# Create Auto scaling Group for Public Servers
resource "aws_autoscaling_group" "public_asg" {
  launch_configuration = aws_launch_configuration.my-test-launch-config.name
  vpc_zone_identifier  = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]
  target_group_arns    = [aws_lb_target_group.my-target-group.arn]
  health_check_type    = "EC2"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "my-test-asg"
    propagate_at_launch = true
  }
}

# Create Auto scaling Group for Private Server A
resource "aws_autoscaling_group" "privateA_asg" {
  launch_configuration = aws_launch_configuration.my-test-launch-config.name
  vpc_zone_identifier  = [
    aws_subnet.private_A[0].id,
    aws_subnet.private_A[1].id
  ]
  target_group_arns    = [aws_lb_target_group.my-target-group.arn]
  health_check_type    = "EC2"
  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "private_asg"
    propagate_at_launch = true
  }
}

# Create Auto scaling Group for Private Server B
resource "aws_autoscaling_group" "privateB_asg" {
  launch_configuration = aws_launch_configuration.my-test-launch-config.name
  vpc_zone_identifier  = [
    aws_subnet.private_B[0].id,
    aws_subnet.private_B[1].id
  ]
  target_group_arns    = [aws_lb_target_group.my-target-group.arn]
  health_check_type    = "EC2"
  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "private_asg"
    propagate_at_launch = true
  }
}