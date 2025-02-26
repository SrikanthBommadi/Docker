# variable "vpc_id" {
  
# }

variable "common_tags" {
    default = {
        name = "docker"

    }
  
}
variable "project_name" {
    default = "docker-ec2"
  
}
variable "environment" {
    default = "develop"
  
}
variable "sg_tags" {
  default = {}
}