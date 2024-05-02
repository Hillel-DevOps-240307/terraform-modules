variable "vpc_cidr" {
    description = "VPC CIDR"
    type = string
    default = ""
}

variable "public_subnets" {
    description = "Public subnets cidr blocks"
    type = list(string)
    default = []
}

variable "auto_assign_public_ip" {
    description = "Enable auto-assign public ip"
    type = bool
    default = false
}

variable "private_subnets" {
    description = "Private subnets cidr blocks"
    type = list(string)
    default = []
}

variable "env_name" {
    description = "Environment name tag"
    type = string
    default = "test"
}

variable "custom_tags" {
    description = "Additional tags"
    type = map(string)
    default = {}
}