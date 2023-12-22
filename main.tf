terraform {
  backend "s3" {
    bucket = "vidhyarthi-tool-state-file"
    key    = "samir-State-File/terraform.tfstate"
    region = "us-west-1"
  }
}


module "network_module" {

  source = "./network"

  /*--------------- VPC ---------------*/



  vpc_cidr                 = var.root_vpc_cidr
  vpc_name                 = var.root_vpc_name
  vpc_enable_dns_hostnames = var.root_vpc_enable_dns_hostnames
  vpc_enable_dns_support   = var.root_vpc_enable_dns_support

  /*--------------- Public Subnets ---------------*/

  public_subnets_cidr = var.root_public_subnets_cidr
  public_subnets_az   = var.root_public_subnets_az
  public_subnets_tags = var.root_public_subnets_tags

  /*--------------- Private Subnets ---------------*/

  private_subnets_cidr = var.root_private_subnets_cidr
  private_subnets_az   = var.root_private_subnets_az
  private_subnets_tags = var.root_private_subnets_tags

  /*--------------- # Internet Gateway ---------------*/

  igw_name = var.root_igw_name

  /*--------------- NAT Gateway ---------------*/

  nat_name = var.root_nat_name

  /*--------------- Public RTB ---------------*/

  pub_route_table_name = var.root_pub_route_table_name

  /*--------------- Private RTB ---------------*/

  pri_route_table_name = var.root_pri_route_table_name

}



module "security_module" {

  source = "./security"

  /*--------------- Bastion SG ---------------*/

  bastion_sg_name      = var.root_bastion_sg_name
  vpc_id               = module.network_module.vpc-id
  public_ingress_ports = var.root_public_ingress_ports

  /*--------------- Private SG ---------------*/

  private_sg_name       = var.root_private_sg_name
  public_subnets_cidr   = [var.root_public_subnets_cidr[0]]
  private_ingress_ports = var.root_private_ingress_ports

  /*--------------- Key Pair | ami-id ---------------*/

  ami_id   = data.aws_ami.ubuntu.id
  key_pair = var.root_key_pair

  /*--------------- Bastion Instance ---------------*/

  public_instance_count      = var.root_public_instance_count
  bastion_instance_subnet_id = module.network_module.public-subnets-id[0]
  bastion_instance_name      = var.root_bastion_instance_name
  bastion_instance_type      = var.root_bastion_instance_type


  /*--------------- Private Instance ---------------*/

  private_instance_count     = var.root_private_instance_count
  private_instance_subnet_id = module.network_module.private-subnets-id
  private_instance_name      = var.root_private_instance_name
  private_instance_type      = var.root_private_instance_type

  public_subnet_id  =  module.network_module.public-subnets-id

}
