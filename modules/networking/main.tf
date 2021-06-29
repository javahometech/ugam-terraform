resource "aws_vpc" "main" {
  cidr_block       = var.vpc_config.cidr_block
  instance_tenancy = var.vpc_config.instance_tenancy
  tags             = var.vpc_config.tags
}
# public subnets

resource "aws_subnet" "public" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)

  tags = {
    Name = "${var.app_name}-public-subnet${count.index + 1}"
  }
}

# create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.app_name}-igw"
  }
}
# create route table for public subnets

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# attach public subnets to public route table

resource "aws_route_table_association" "a" {
  count          = length(local.pub_sub_ids)
  subnet_id      = local.pub_sub_ids[count.index]
  route_table_id = aws_route_table.public.id
}
# create private subnets

resource "aws_subnet" "private" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main.id
  availability_zone = local.az_names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + length(local.az_names))

  tags = {
    Name = "${var.app_name}-private-subnet${count.index + 1}"
  }
}

# create eip for NAT gateway
resource "aws_eip" "nat" {
  vpc      = true
}

# create nat gateway
/*
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = local.pub_sub_ids[0]

  tags = {
    Name = "${var.app_name}-nat-gateway"
  }
  depends_on = [aws_internet_gateway.gw]
}
*/

# create route table for private subnets

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_nat_gateway.main.id
  # }

  tags = {
    Name = "private-rt"
  }
}

# attach public subnets to public route table

resource "aws_route_table_association" "b" {
  count          = length(local.pri_sub_ids)
  subnet_id      = local.pri_sub_ids[count.index]
  route_table_id = aws_route_table.private.id
}