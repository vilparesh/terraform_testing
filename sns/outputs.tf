output "sns_arn" {
  value = "${aws_sns_topic.emxcel_sns_alarm.arn}"
}