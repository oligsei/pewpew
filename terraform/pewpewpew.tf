provider "aws" {
  version = "~> 2.0"
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "pew-pew-pew-remote"
    key = "pewpew.reznikov.eu"
    region = "eu-central-1"
  }
}

resource "aws_s3_bucket" "s3Bucket" {
  bucket = "pewpew.reznikov.eu"
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
      "Resource": "arn:aws:s3:::pew-pew-pew/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
  }
}
