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
