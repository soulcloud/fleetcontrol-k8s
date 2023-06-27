# Bucket creation
resource "aws_s3_bucket" "kops" {
    bucket = "fleetcontrol-state-store"
    
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "kops_versioning" {
    bucket = aws_s3_bucket.kops.id
    versioning_configuration {
    status = "Enabled"
}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kops_sse_config" {
  bucket = aws_s3_bucket.kops.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket" "soul-kops-oidc-store" {
  bucket = "soul-kops-oidc-store"
}

resource "aws_s3_bucket_ownership_controls" "kops_bucket_ownership_controls" {
  bucket = aws_s3_bucket.soul-kops-oidc-store.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "kops_oidc_public_access" {
  bucket = aws_s3_bucket.soul-kops-oidc-store.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "kops_iodc_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.kops_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.kops_oidc_public_access,
  ]

  bucket = aws_s3_bucket.soul-kops-oidc-store.id
  acl    = "public-read"
}