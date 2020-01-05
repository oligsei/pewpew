variable "WEBSITE_URL" {}

variable "AWS_REGION" {
  default = "eu-central-1"
}

provider "aws" {
  version = "~> 2.0"
  region = var.AWS_REGION
}

terraform {
  backend "s3" {
    bucket = "sync-remote"
    key = var.WEBSITE_URL
    region = var.AWS_REGION
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.WEBSITE_URL
  acl = "public-read"

  policy = <<EOF
{
  "Id": "MakePublic",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.WEBSITE_URL}/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}
