resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "project_1_alarm_cpu"
  alarm_description   = "This alarm monitors for high CPU utilization on EC2 instances."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  dimensions = {
    InstanceId = aws_instance.app_server.id
  }
  alarm_actions = [aws_sns_topic.cpu_alerts.arn]
}