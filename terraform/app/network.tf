################################################################################
# VPC
################################################################################

resource "aws_vpc" "vpc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "10.0.0.0/24"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "sg" {
    name   = "mlops-intro-sg"
    vpc_id = aws_vpc.vpc.id

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = "0"
        protocol    = "-1"
        self        = "false"
        to_port     = "0"
    }

    ingress {
        from_port = "0"
        protocol  = "-1"
        self      = "true"
        to_port   = "0"
    }

    ingress {
        from_port = "0"
        protocol  = "-1"
        to_port   = "0"
        cidr_blocks = [aws_vpc.vpc.cidr_block]
    }
}

################################################################################
# Public subnets
################################################################################

resource "aws_subnet" "public_subnet1" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.0.0.0/26"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = "eu-west-2a"

  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet2" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.0.0.64/26"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"
  availability_zone                              = "eu-west-2b"

  vpc_id = aws_vpc.vpc.id
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public_route_table" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  vpc_id = aws_vpc.vpc.id
}

################################################################################
# EIPs
################################################################################

resource "aws_eip" "eip1" {
  network_border_group = "eu-west-2"
  public_ipv4_pool     = "amazon"
  vpc                  = "true"
}

resource "aws_eip" "eip2" {
  network_border_group = "eu-west-2"
  public_ipv4_pool     = "amazon"
  vpc                  = "true"
}

################################################################################
# NAT Gateways
################################################################################

resource "aws_nat_gateway" "nat1" {
  allocation_id     = aws_eip.eip1.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnet1.id
}

resource "aws_nat_gateway" "nat2" {
  allocation_id     = aws_eip.eip2.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public_subnet2.id

}

################################################################################
# Networking interfaces (private IPs get auto generated) - Not sure if needed 
################################################################################

resource "aws_network_interface" "nic1" {
  ipv4_prefix_count  = "0"
  ipv6_address_count = "0"
  ipv6_prefix_count  = "0"
  private_ips_count  = "0"
  source_dest_check  = "false"
  subnet_id          = aws_subnet.public_subnet1.id
}

resource "aws_network_interface" "nic2" {
  ipv4_prefix_count  = "0"
  ipv6_address_count = "0"
  ipv6_prefix_count  = "0"
  private_ips_count  = "0"
  source_dest_check  = "false"
  subnet_id          = aws_subnet.public_subnet2.id
}

################################################################################
# Network ACL ---
################################################################################

resource "aws_network_acl" "acl_pub" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "10.0.0.0/24"
    from_port  = "0"
    protocol   = "tcp"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  vpc_id     = aws_vpc.vpc.id

}

################################################################################
# Route table association
################################################################################

resource "aws_route_table_association" "rta1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet1.id
}

resource "aws_route_table_association" "rta2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet2.id
}

################################################################################
# Main Route table association - Needed?
################################################################################

resource "aws_main_route_table_association" "main_rta" {
  route_table_id = aws_route_table.public_route_table.id
  vpc_id         = aws_vpc.vpc.id
}