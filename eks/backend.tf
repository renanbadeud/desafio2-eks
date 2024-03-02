terraform {
  backend "s3" {
    bucket = "tfstatebucket321"
    key    = "backend.tfstate"
    region = "us-east-1"
  }
}