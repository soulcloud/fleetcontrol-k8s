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
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
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










# resource "aws_spot_instance_request" "spot-test" {
#   ami           = "ami-053b0d53c279acc90"
#   spot_price    = "0.03"
#   instance_type = "c4.xlarge"

#   tags = {
#     Name = "CheapWorker"
#   }
# }