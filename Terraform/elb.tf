
resource "aws_lb" "SAS-POC-ELB" {
  name               = "SAS-POC-ELB"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.DMZ-subnet.id}"]

  enable_deletion_protection = true

  tags {
    Workload ="${var.tags_Workload}"
    Creater = "${var.tags_Creater}"
    BusinessOwner ="${var.tags_BusinessOwner}"
    ChargeCode = "${var.tags_ChargeCode}"
    Env = "${var.tags_Env}"
  }
}