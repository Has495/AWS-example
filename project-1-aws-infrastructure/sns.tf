resource "aws_sns_topic" "cpu_alerts" {
  name = "project-1-cpu-alerts"
}
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.cpu_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}