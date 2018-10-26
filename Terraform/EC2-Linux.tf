resource "aws_instance" "EC2-Ansible" {
ami = "ami-28e07e50"
instance_type = "t3.medium"
subnet_id = "${aws_subnet.DMZ-subnet.id}"
tags {
Name = "SAS-POC-Pub-Ansible"
Workload ="${var.tags_Workload}"
Creater = "${var.tags_Creater}"
BusinessOwner ="${var.tags_BusinessOwner}"
ChargeCode = "${var.tags_ChargeCode}"
Env = "${var.tags_Env}"
}
# create security group
vpc_security_group_ids = ["${aws_security_group.sgdmz.id}"] subnet_id = "${aws_subnet.DMZ-subnet.id}"
source_dest_check = false

key_name = "${var.key_name}"
}