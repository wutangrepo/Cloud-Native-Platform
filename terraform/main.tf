resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

# --- VPC Setup ---
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# --- Internet Gateway ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}
# --- Public Subnets ---
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                         = "${var.project_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb"                     = "1"      # k8s puts elb in public subnet
    "kubernetes.io/clusters/${var.project_name}" = "shared" # Ownership, telling k8s cluster this subnet is available for use
  }
}

# -- Private Subnets ---
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name                                         = "${var.project_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/elb"                     = "1"
    "kubernetes.io/clusters/${var.project_name}" = "shared"
  }
}

# ---NAT Gateway ---
resource "aws_eip" "nat" {
  domain = "vpc" # legacy requirement for VPC: eip must be in this VPC 
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # for cost control, only 1 NAT gateway in the first public subnet，not good for production use

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.main] # build IGW first, otherwise crash with error of missing route to IGW, "Network Unreachable", as we didn't mention IGW here
}

# --- Route Tables ---

# Public Route Table (Traffic to IGW )
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                  # Anywhere not in Public subnet
    gateway_id = aws_internet_gateway.main.id # pointing to IGW, not belonging like vpc_id = aws_vpc.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Private Route Table (Traffic to NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"             # not in Private
    nat_gateway_id = aws_nat_gateway.main.id # Terraform is extremely specific about Types
  }
  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# --- Route Table Associations ---

# Public Subnet Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnet Associations
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}