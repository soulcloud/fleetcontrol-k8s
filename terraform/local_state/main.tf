terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_vpc" "k8s-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    } 
}

resource "aws_subnet" "k8s-subnet-1" {
    vpc_id = aws_vpc.k8s-vpc.id 
    cidr_block = var.subnet_cidr_block_1
    availability_zone = var.avail_zone_1
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

resource "aws_subnet" "k8s-subnet-2" {
    vpc_id = aws_vpc.k8s-vpc.id 
    cidr_block = var.subnet_cidr_block_2
    availability_zone = var.avail_zone_2
    tags = {
        Name: "${var.env_prefix}-subnet-2"
    }
}
resource "aws_security_group" "k8s-sg" {
    name = "k8s-sg"
    vpc_id = aws_vpc.k8s-vpc.id

    #ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

}

resource "aws_internet_gateway" "k8s-igw" {
    vpc_id = aws_vpc.k8s-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_route_table" "k8s-route-table" {
    vpc_id = aws_vpc.k8s-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.k8s-subnet-1.id
    route_table_id = aws_route_table.k8s-route-table.id
}

resource "aws_key_pair" "ssh-key" {
    key_name = "traplanje"
    public_key = "${file(var.public_key_location)}"
}

# Bucket creation
resource "aws_s3_bucket" "kops" {
    bucket = "fleetcontrol-state-storage"
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


resource "aws_s3_bucket_ownership_controls" "kops_bucket_ownership" {
  bucket = aws_s3_bucket.kops.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# resource "aws_s3_bucket_public_access_block" "kops_bucket_public_access" {
#   bucket = aws_s3_bucket.kops.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "kops_bucket_acl" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.kops_bucket_ownership,
#     aws_s3_bucket_public_access_block.kops_bucket_public_access,
#   ]

#   bucket = aws_s3_bucket.kops.id
#   acl    = "public-read"
# }



# resource "aws_spot_instance_request" "spot-test" {
#   ami           = "ami-053b0d53c279acc90"
#   spot_price    = "0.03"
#   instance_type = "c4.xlarge"

#   tags = {
#     Name = "CheapWorker"
#   }
# }