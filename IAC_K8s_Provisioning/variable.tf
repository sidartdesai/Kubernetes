variable "project" {
    type = string
    description = "name of the project for this repo"
    default = "Kubernetes"
}

variable "ubuntu-ami" {
  type = string
}

variable "master_instance_type" {
  type = string
}

variable "node_instance_type" {
  type = string
}

variable "subnet-id" {
  type = string
}
