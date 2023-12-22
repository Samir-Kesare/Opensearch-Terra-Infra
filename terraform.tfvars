/*---------------vpc variables---------------*/

root_vpc_cidr                 = "10.0.0.0/16"
root_vpc_enable_dns_hostnames = true
root_vpc_enable_dns_support   = true
root_vpc_name                 = "ninja-vpc-01"

/*---------------subnet variables---------------*/

/*--------------- Public Subnets ---------------*/

root_public_subnets_az   = ["us-east-2a", "us-east-2b"]
root_public_subnets_cidr = ["10.0.2.0/24", "10.0.4.0/24"]
root_public_subnets_tags = [{

  "Name" = "ninja-pub-sub-01"

  },
  {
    "Name" = "ninja-pub-sub-02"
}]
root_enable_map_public_ip_on_launch = true

/*--------------- Private Subnets ---------------*/

root_private_subnets_az   = ["us-east-2a", "us-east-2b"]
root_private_subnets_cidr = ["10.0.6.0/24", "10.0.8.0/24"]
root_private_subnets_tags = [{
  "Name" = "ninja-priv-sub-01"
  },
  {
    "Name" = "ninja-priv-sub-02"
}]

/*--------------- # Internet Gateway ---------------*/

root_igw_name = "ninja-igw-01"

/*--------------- # NAT Gateway ---------------*/

root_nat_name = "ninja-nat-01"

/*--------------- Public RTB ---------------*/

root_pub_route_table_name = "ninja-route-pub-01"

/*--------------- Private RTB ---------------*/

root_pri_route_table_name = "ninja-route-priv-01"

/*---------------\/\/ Security Module \/\/---------------*/

/*--------------- SG ---------------*/

root_public_ingress_ports  = [22, 443, 80]
root_private_ingress_ports = [22, 9200, 5601]
root_bastion_sg_name       = "bastion-SG"
root_private_sg_name       = "private-SG"

/*--------------- Key Pair ---------------*/

root_key_pair = "private-key"

/*--------------- Bastion Instance ---------------*/

root_public_instance_count = "1"
root_bastion_instance_name = "bastion-instance"
root_bastion_instance_type = "t2.micro"

/*--------------- Private Instance ---------------*/

root_private_instance_count = "1"
root_private_instance_name  = "opensearch-instance"
root_private_instance_type  = "t2.medium"
