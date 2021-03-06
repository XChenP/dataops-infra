# NOTE: IAM role includes actions for executing a Glue data transformation job

resource "aws_iam_role" "glue_job_role" {
  name = "${var.name_prefix}GlueJobRole"

  tags = var.resource_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "glue.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "glue_job_policy" {
  name        = "${var.name_prefix}GlueJobPolicy"
  description = "Policy for Glue role"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_script_bucket_name}",
                "arn:aws:s3:::${var.s3_source_bucket_name}",
                "arn:aws:s3:::${var.s3_destination_bucket_name}"
            ]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": [
                "arn:aws:s3:::${var.s3_script_bucket_name}/*",
                "arn:aws:s3:::${var.s3_source_bucket_name}/*",
                "arn:aws:s3:::${var.s3_destination_bucket_name}/*"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "glue_job_policy_attachment" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = aws_iam_policy.glue_job_policy.arn
}
