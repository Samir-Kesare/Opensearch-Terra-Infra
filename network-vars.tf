/*---------------vpc variables---------------*/

variable "root_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "root_vpc_enable_dns_support" {
  type    = bool
  default = true
}

variable "root_vpc_enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "root_vpc_name" {
  type    = string
  default = "ninja-vpc-01"
}
/*---------------subnet variables---------------*/

/*--------------- Public Subnets ---------------*/

variable "root_public_subnets_cidr" {
  description = "public subnet cidr block"
  type        = list(string)
  default     = ["10.0.2.0/24"]

}

variable "root_public_subnets_az" {
  description = "public subnet availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]
}
variable "root_enable_map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "root_public_subnets_tags" {
  description = "public subnet tags"
  type        = list(map(string))
  default = [{
    "Name" = "ninja-pub-sub-01"

  }]
}

/*--------------- Private Subnets ---------------*/

variable "root_private_subnets_cidr" {
  description = "private subnet cidr block"
  type        = list(string)
  default     = ["10.0.6.0/24", "10.0.8.0/24"]

}

variable "root_private_subnets_az" {
  description = "private subnet availability zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]

}

variable "root_private_subnets_tags" {
  description = "private subnet tags"
  type        = list(map(string))
  default = [{
    "Name" = "ninja-priv-sub-01"

  }]
}

/*--------------- # Internet Gateway ---------------*/

variable "root_igw_name" {
  type    = string
  default = "ninja-igw-01"
}

/*--------------- # NAT Gateway ---------------*/

variable "root_nat_name" {
  type    = string
  default = "ninja-nat-01"
}

/*--------------- # Route Table ---------------*/

variable "root_pub_route_table_name" {
  type    = string
  default = "ninja-route-pub-01"
}

variable "root_pri_route_table_name" {
  type    = string
  default = "ninja-route-priv-01"
}

