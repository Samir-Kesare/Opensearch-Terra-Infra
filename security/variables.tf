/*--------------- Public SG variables ---------------*/

variable "public_ingress_ports" {
  description = "SG inbound ports"
  type        = list(number)
  default     = [22, 443, 80]
}
variable "bastion_sg_name" {
  type    = string
  default = "bastion-SG"
}


/*--------------- Private SG variables ---------------*/

variable "private_ingress_ports" {
  description = "SG inbound ports"
  type        = list(number)
  default     = [22]
}

variable "private_sg_name" {
  type    = string
  default = "private-SG"
}
variable "public_subnets_cidr" {
  type = list(string)
}
variable "vpc_id" {
    type    = string
}
/*--------------- Key pair variables ---------------*/

variable "key_pair" {
  type    = string
  default = "ninja-01"
}

/*--------------- AMI variables---------------*/

variable "ami_id" {
  type    = string
  default = "ami-00983e8a26e4c9bd9"
}

/*--------------- Bastion Instance ---------------*/
variable "public_instance_count" {
  description = "Number of public instances to create"
  type        = number
  default     = 1
}

variable "bastion_instance_type" {
  description = "type of instance for bastion server"
  type        = string
  default     = "t2.micro"
}

variable "bastion_instance_name" {
  description = "bastion instance name"
  type        = string
  default     = "bastion-instance"
  
}

variable "bastion_instance_subnet_id" {
    type    = string
}

/*--------------- Private Instance ---------------*/

variable "private_instance_count" {
  description = "Number of private instances to create"
  type        = number
  default     = 2
}

variable "private_instance_type" {
  description = "type of instance for bastion server"
  type        = string
  default     = "t2.medium"
}

variable "private_instance_name" {
  description = "private instance name"
  type        = string
  default     = "private-instance"  
}

variable "private_instance_subnet_id" {
    type    = list(string)
}

variable "public_subnet_id" {
     type        = list(string)
}