# Create aws_route_table for Public Subnets

resource "aws_route_table" "route_public" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  vpc_id = aws_vpc.main.id
  # tags = {
  #   Name        = format("Public-RT-%s",aws_route_table.route_public[count.index])
  # }
}

# Create aws_route for Public Subnets
resource "aws_route" "public" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  route_table_id         = aws_route_table.route_public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Create aws_route_table_association for Public Subnets
resource "aws_route_table_association" "Public_Subnet" {
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.route_public[count.index].id
}
