output "ami_id" {
    value = data.aws_ami.docker.id
}
output "instace_id" {
    value = aws_instance.docker.public_ip
  
}