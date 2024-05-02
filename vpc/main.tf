data "aws_availability_zones" "current" {}

resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = merge({
      Name = "${var.env_name}-vpc"
    }, var.custom_tags)
}

locals {
  create_public_subnets = length(var.public_subnets) > 0
  create_private_subnets = length(var.private_subnets) > 0
}

# public

resource "aws_subnet" "public_subnet" {
    count = local.create_public_subnets ? length(var.public_subnets) : 0

    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnets[count.index]
    availability_zone = data.aws_availability_zones.current.names[count.index]
    map_public_ip_on_launch = var.auto_assign_public_ip
    tags = merge({
      Name = "${var.env_name}-subnets"
    }, var.custom_tags)
}

resource "aws_internet_gateway" "this" {
    count = local.create_public_subnets ? 1 : 0
    vpc_id = aws_vpc.this.id

    tags = merge({
      Name = "${var.env_name}-igw"
    }, var.custom_tags)
}

resource "aws_route_table" "public-rt" {
    count = local.create_public_subnets ? 1 : 0
    vpc_id = aws_vpc.this.id
    
    tags = merge({
      Name = "${var.env_name}-public-rt"
    }, var.custom_tags)
}

resource "aws_route" "public-route" {
    count = local.create_public_subnets ? 1 : 0
    route_table_id = aws_route_table.public-rt[0].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
   
}

resource "aws_route_table_association" "public-rta" {
    count = local.create_public_subnets ? length(var.public_subnets) : 0
    route_table_id = aws_route_table.public-rt[0].id
    subnet_id = aws_subnet.public_subnet[count.index].id
  
}

# private

resource "aws_subnet" "private_subnet" {
    count = local.create_private_subnets ? length(var.private_subnets) : 0

    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnets[count.index]
    availability_zone = data.aws_availability_zones.current.names[count.index]
    tags = merge({
      Name = "${var.env_name}-private-subnet"
      cidr = "${var.private_subnets[count.index]}"
    }, var.custom_tags)
}

resource "aws_route_table" "private-rt" {
    count = local.create_private_subnets ? 1 : 0
    vpc_id = aws_vpc.this.id
    
    tags = merge({
      Name = "${var.env_name}-private-rt"
    }, var.custom_tags)
}

resource "aws_route_table_association" "private-rta" {
    count = local.create_private_subnets ? length(var.private_subnets) : 0
    route_table_id = aws_route_table.private-rt[0].id
    subnet_id = aws_subnet.private_subnet[count.index].id
  
}