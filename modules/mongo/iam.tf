resource "aws_iam_instance_profile" "mongo" {
  name_prefix = "mongo_ec2"
  role        = aws_iam_role.mongo.name
}

resource "aws_iam_role" "mongo" {
  name_prefix        = "mongo_iam_role"
  path               = "/mongo/"
  assume_role_policy = data.aws_iam_policy_document.mongo.json
}

data "aws_iam_policy_document" "mongo" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "mng" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "mongo_mng" {
  role       = aws_iam_role.mongo.name
  policy_arn = data.aws_iam_policy.mng.arn
}
