terraform {
  backend "s3" {
    bucket = "tf-statebucket123"
    key    = "backend.tfstate"
    region = "us-east-2"
  }
}