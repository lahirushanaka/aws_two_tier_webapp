
variable "environment" {
    type = string
     
}

variable "network_cidr" {
#   type    = list(object({
#       dev = string
#       uat = string
#       production = string
#   }))
#   default = {
#     dev    = "10.0.0.0/24"
#     uat        = "10.0.1.0/24"
#     production = "10.0.2.0/24"
#   }
}

variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "private_subnet_cidrs" {
#   type    = list(object({
#       dev = string
#       uat = string
#       production = string
#   }))
#   default = {
#     dev    = ["10.0.0.0/26", "10.0.0.64/26"]
#     uat         = ["10.0.1.0/26", "10.0.1.64/26"]
#     production = ["10.0.2.0/26", "10.0.2.64/26"]
#   }
}

variable "public_subnet_cidrs" {
#   type    = list(object({
#       dev = string
#       uat = string
#       production = string
#   }))
#   default = {
#     dev    = ["10.0.0.128/26", "10.0.0.192/26"]
#     uat         = ["10.0.1.128/26", "10.0.1.192/26"]
#     production = ["10.0.2.128/26", "10.0.2.192/26"]
#   }
}

