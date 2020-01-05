variable "WEBSITE_URL" {
  type = string
  default = "pewpew.reznikov.eu"
}

provider "aws" {
  version = "~> 2.0"
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "sync-remote"
    key = "terraform/state/${var.WEBSITE_URL}"
    region = "eu-central-1"
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
