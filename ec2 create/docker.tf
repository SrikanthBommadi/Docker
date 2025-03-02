resource "aws_instance" "docker" {
    ami = local.ami_id
    instance_type = local.instance_type
    vpc_security_group_ids = [aws_security_group.docker.id]
    tags = merge(
        var.common_tags,
        var.sg_tags,
        {
            Name= local.resource_name
        }
    )

root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }

 provisioner "remote-exec" {
    inline = [
      "sudo dnf -y install dnf-plugins-core",
      "sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
      "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo systemctl enable --now docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = "DevOps321"
    host        = self.public_ip
  }
}


resource "aws_security_group" "docker" {
    name = "docker"
    description = " in-bound/outbont"  
 ingress {
    from_port   = 22   ###ssh##
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 80  ###ssh##
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name="docker"
  }
}
