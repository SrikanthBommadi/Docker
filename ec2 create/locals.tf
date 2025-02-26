locals {
  ami_id=data.aws_ami.docker.id
  instance_type="t3.micro"
  resource_name="${var.project_name}-${var.environment}"
}
