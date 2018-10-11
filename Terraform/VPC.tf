# Define Provider
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}
# Define VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "sas-poc-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "DMZ-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "DMZ Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-A-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr1}"
  availability_zone = "us-west-2b"

  tags {
    Name = "Private Subnet A"
  }
}


# Define the private subnet 2
resource "aws_subnet" "private-B-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr2}"
  availability_zone = "us-west-2b"

  tags {
    Name = "Private Subnet B"
  }
}

# Define the private subnet 3
resource "aws_subnet" "private-C-subnet" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_cidr3}"
  availability_zone = "us-west-2c"

  tags {
    Name = "Spare Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Define the nat gateway
resource "aws_eip" "tuto_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.tuto_eip.id}"
    subnet_id = "${aws_subnet.DMZ-subnet.id}"
    depends_on = ["aws_internet_gateway.gw"]
}

# Define the route table DMZsubnet
resource "aws_route_table" "DMZ-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "DMZ Subnet RT"
  }
}

# Assign the route table to the public DMZ Subnet
resource "aws_route_table_association" "DMZ-public-rt" {
  subnet_id = "${aws_subnet.DMZ-subnet.id}"
  route_table_id = "${aws_route_table.DMZ-public-rt.id}"
}



# Define the route table Private subnet A
resource "aws_route_table" "private-a-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "Private A Subnet RT"
  }
}

# Assign the route table to the Private A Subnet
resource "aws_route_table_association" "private-a-rt" {
  subnet_id = "${aws_subnet.private-A-subnet.id}"
  route_table_id = "${aws_route_table.private-a-rt.id}"
}

# Define the route table Priate B subnet
resource "aws_route_table" "private-b-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "Private B Subnet RT"
  }
}

# Define the route table Priate C subnet
resource "aws_route_table" "private-c-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "Private C Subnet RT"
  }
}

# Assign the route table to the private B Subnet
resource "aws_route_table_association" "private-b-rt" {
  subnet_id = "${aws_subnet.private-B-subnet.id}"
  route_table_id = "${aws_route_table.private-b-rt.id}"
}

# Assign the route table to the private C Subnet
resource "aws_route_table_association" "private-c-rt" {
  subnet_id = "${aws_subnet.private-C-subnet.id}"
  route_table_id = "${aws_route_table.private-c-rt.id}"
}

# Define the security group for public subnet
resource "aws_security_group" "sgdmz" {
  name = "vpc_test_dmz"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.default.id}"

  tags {
    Name = "Web Server DMZ"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sgtest"{
  name = "sg_test"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Test SG"
  }
}