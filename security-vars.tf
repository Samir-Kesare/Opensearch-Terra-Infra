/*---------------SG variables---------------*/

variable "root_public_ingress_ports" {
  type        = list(number)
  description = "SG inbound ports"
  default     = [22, 443, 80]
}
variable "root_bastion_sg_name" {
  type    = string
  default = "bastion-SG"
}

variable "root_private_ingress_ports" {
  type        = list(number)
  description = "SG inbound ports"
  default     = [22, 7000, 7001, 9042]
}
variable "root_private_sg_name" {
  type    = string
  default = "private-SG"
}

/*--------------- Key pair variables ---------------*/

variable "root_key_pair" {
  type    = string
  default = "ninja-01"
}

/*--------------- Bastion Instance ---------------*/
variable "root_public_instance_count" {
  description = "Number of public instances to create"
  type        = number
  default     = 1
}

variable "root_bastion_instance_type" {
  description = "type of instance for bastion server"
  type        = string
  default     = "t2.medium"

}

variable "root_bastion_instance_name" {
  description = "bastion instance name"
  type        = string
  default     = "bastion-instance"

}

/*--------------- Private Instance ---------------*/

variable "root_private_instance_count" {
  description = "Number of private instances to create"
  type        = number
  default     = 2
}


variable "root_private_instance_type" {
  description = "type of instance for bastion server"
  type        = string
  default     = "t2.medium"

}

variable "root_private_instance_name" {
  description = "private instance name"
  type        = string
  default     = "private-instance"

}
