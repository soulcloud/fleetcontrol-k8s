# Bootstrap
resource "aws_instance" "bootstrap" {
  ami                    = var.ami_ubuntu
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.ssh-key.key_name
  subnet_id              = aws_subnet.k8s-subnet-1.id
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.volume_size_small
    volume_type = var.volume_type
  }

  # Copy the bash script to the new instance
  provisioner "file" {
    source      = "install-kubectl-and-kops.sh"
    destination = "/tmp/install-kubectl-and-kops.sh"
  }

  # Change permissions on the bash script and execute it
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-kubectl-and-kops.sh",
      "/tmp/install-kubectl-and-kops.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_location)
    host        = self.public_ip
    }
  

  tags = {
    Name = "bootstrap"
  }
}


# resource "aws_spot_instance_request" "spot-test" {
#   ami           = "ami-053b0d53c279acc90"
#   spot_price    = "$0.0258"
#   instance_type = "t3.medium"
#   key_name      = aws_key_pair.ssh-key.key_name
#   subnet_id     = aws_subnet.k8s-subnet-1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   associate_public_ip_address = true
#   tags = {
#     Name = "spot-test"
#   }
# }

# resource "aws_instance" "test" {
#   ami           = "ami-053b0d53c279acc90"
#   instance_type = "t3.medium"
#   key_name      = aws_key_pair.ssh-key.key_name
#   subnet_id     = aws_subnet.k8s-subnet-1.id
#   vpc_security_group_ids = [aws_security_group.k8s-sg.id]
#   associate_public_ip_address = true
#   tags = {
#     Name = "test"
#   }
# }

