resource "aws_sns_topic" "scaleup_alarm" {
  name = "scaleup_alarm"
}

resource "aws_sns_topic" "scaledown_alarm" {
  name = "scaledown_alarm"
}

resource "aws_sns_topic" "servicelatency" {
  name = "servicelatency"

}
