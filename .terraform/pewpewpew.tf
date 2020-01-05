variable "WEBSITE_URL" {
  type = string
}

provider "aws" {
  version = "~> 2.0"
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "sync-remote"
    key = "terraform/state/pewpew.reznikov.eu"
    region = "eu-central-1"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.WEBSITE_URL
  acl = "public-read"

  policy = jsonencode({
    Id: "MakePublic",
    Version: "2012-10-17",
    Statement: [
      {
        Action: [
          "s3:GetObject"
        ],
        Effect: "Allow",
        Resource: "arn:aws:s3:::${var.WEBSITE_URL}/*",
        Principal: "*"
      }
    ]
  })

  website {
    index_document = "index.html"
  }
}
