resource "aws_iam_role" "lambda" {
  name = "TesteLambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name        = "TesteLambdaBasicExecutionRolePolicy"
  path        = "/"
  description = "Provides write permissions to CloudWatch Logs, S3 buckets and EMR Steps"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticmapreduce:*"
            ],
            "Resource": "*"
        },
        {
          "Action": "iam:PassRole",
          "Resource": ["arn:aws:iam::937185187804:role/EMR_DefaultRole",
                       "arn:aws:iam::937185187804:role/EMR_EC2_DefaultRole"],
          "Effect": "Allow"
        }
    ]
}
EOF
} # dentro de "PassRole" em "Resource", trocar pelo ID da sua conta

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

# resource "aws_iam_role" "glue_role" {
#   name = "AWSGlueCrawlerRole"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "glue.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy" "glue_policy" {
#   name        = "AWSGlueServiceRole"
#   path        = "/"
#   description = "Policy for AWS Glue service role which allows access to related services including EC2, S3, and Cloudwatch Logs"

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "glue:*",
#                 "s3:GetBucketLocation",
#                 "s3:ListBucket",
#                 "s3:ListAllMyBuckets",
#                 "s3:GetBucketAcl",
#                 "ec2:DescribeVpcEndpoints",
#                 "ec2:DescribeRouteTables",
#                 "ec2:CreateNetworkInterface",
#                 "ec2:DeleteNetworkInterface",
#                 "ec2:DescribeNetworkInterfaces",
#                 "ec2:DescribeSecurityGroups",
#                 "ec2:DescribeSubnets",
#                 "ec2:DescribeVpcAttribute",
#                 "iam:ListRolePolicies",
#                 "iam:GetRole",
#                 "iam:GetRolePolicy",
#                 "cloudwatch:PutMetricData"
#             ],
#             "Resource": [
#                 "*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:CreateBucket"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::aws-glue-*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:GetObject",
#                 "s3:PutObject",
#                 "s3:DeleteObject"
#             ],
#             "Resource": [
#                 "*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogGroup",
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": [
#                 "arn:aws:logs:*:*:/aws-glue/*"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CreateTags",
#                 "ec2:DeleteTags"
#             ],
#             "Condition": {
#                 "ForAllValues:StringEquals": {
#                     "aws:TagKeys": [
#                         "aws-glue-service-resource"
#                     ]
#                 }
#             },
#             "Resource": [
#                 "arn:aws:ec2:*:*:network-interface/*",
#                 "arn:aws:ec2:*:*:security-group/*",
#                 "arn:aws:ec2:*:*:instance/*"
#             ]
#         }
#     ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "glue_attach" {
#   role       = aws_iam_role.glue_role.name
#   policy_arn = aws_iam_policy.glue_policy.arn
# }

resource "aws_iam_role" "emr_default_role" {
  name = "EMR_DefaultRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "emr_default_role" {
  role       = aws_iam_role.emr_default_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

resource "aws_iam_role" "emr_ec2_default_role" {
  name = "EMR_EC2_DefaultRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "emr_ec2_default_role" {
  name = aws_iam_role.emr_ec2_default_role.name
  role = aws_iam_role.emr_ec2_default_role.name
}

resource "aws_iam_role_policy_attachment" "emr_ec2_default_role" {
  role       = aws_iam_role.emr_ec2_default_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}