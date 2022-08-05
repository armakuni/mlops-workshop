variable "artefact_source" {
  type = string
}

variable "eb_name" {
  type = string
  default = "mlops-intro-eb"
}

variable "instance_types" {
  type = string
  default = "t2.micro"
  description = "Comma-separated list of instance types"
}

variable "load_balancer_type" {
  type = string
  default = "application"
}

variable "public_subnet_1" {
  type = string
}
variable "public_subnet_2" {
  type = string
}

variable "stream_logs" {
  type = bool
  default = true
}
