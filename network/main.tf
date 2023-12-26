/*--------------- VPC ---------------*/

resource "aws_vpc" "vpc-01" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

/*--------------- Public Subnets ---------------*/

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc-01.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.public_subnets_az[count.index]
  map_public_ip_on_launch = var.enable_map_public_ip_on_launch
  tags                    = var.public_subnets_tags[count.index]
}

/*--------------- Private Subnets ---------------*/

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.private_subnets_az[count.index]
  tags              = var.private_subnets_tags[count.index]
}

/*--------------- # Internet Gateway ---------------*/

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-01.id
  tags = {
    Name = var.igw_name
  }
}

/*--------------- # Elastic IP ---------------*/

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

/*--------------- NAT Gateway ---------------*/

resource "aws_nat_gateway" "ninja_nat" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = var.nat_name
  }
  depends_on = [aws_eip.elastic_ip]
}

/*--------------- Public Route Table ---------------*/

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc-01.id
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
 
  route {
    cidr_block = "172.31.0.0/16"
    gateway_id = aws_vpc_peering_connection.vpc_peering.id
  }
  
  tags = {
    Name = var.pub_route_table_name
  }
  depends_on = [ aws_vpc_peering_connection.vpc_peering ]
}


/*--------------- Public RTB Association ---------------*/

resource "aws_route_table_association" "public_route_association01" {
  count = length(aws_subnet.public_subnets.*.id)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}
/*--------------- Private RTB ---------------*/

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc-01.id
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ninja_nat.id
  }
  route {
    cidr_block = "172.31.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }
  tags = {
    Name = var.pri_route_table_name
  }
  depends_on = [aws_nat_gateway.ninja_nat]
}


/*--------------- Private RTB Association ---------------*/

resource "aws_route_table_association" "private_route_association01" {

  count = length(aws_subnet.private_subnets.*.id)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rtb.id
  depends_on     = [aws_route_table.private_rtb]
}

/*--------------- Default VPC Peering---------------*/


resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id  = "vpc-0c5ad2e49f7ba6a4d"
  vpc_id = aws_vpc.vpc-01.id
  auto_accept = true
  tags = {
    Name = "VPC Peering between default and  New VPC"
  }
}

resource "aws_route" "default-rt" {
  route_table_id            = "rtb-05cafef42ef72084b"  
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  depends_on = [ aws_vpc_peering_connection.vpc_peering ]
}


