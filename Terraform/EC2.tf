 # Lookup the correct AMI based on the region specified
data "aws_ami" "amazon_windows_2016" {
most_recent = true
owners = ["amazon"]
 
filter {
name = "name"
values = ["Windows_Server-2016-English-Full-Base-*"]
}
}
# create instances
resource "aws_instance" "EC2-AD" {
instance_type = "t3.medium"
ami = "${data.aws_ami.amazon_windows_2016.id}"
subnet_id = "${aws_subnet.private-A-subnet.id}"
tags {
    Name = "SAS-POC-Pri-AD"
    Workload ="${var.tags_Workload}"
    Creater = "${var.tags_Creater}"
    BusinessOwner ="${var.tags_BusinessOwner}"
    ChargeCode = "${var.tags_ChargeCode}"
    Env = "${var.tags_Env}"
  }
  # create security group
vpc_security_group_ids = ["${aws_security_group.sgtest.id}"] subnet_id = "${aws_subnet.private-A-subnet.id}"
source_dest_check = false

# The name of our SSH keypair you've created and downloaded
# from the AWS console.
#
# https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs
#
key_name = "${var.key_name}"

user_data = <<EOF
install-windowsfeature AD-Domain-Services
Start-Sleep -s 60
 
Import-Module ADDSDeployment
Start-Sleep -s 60
 
Add-WindowsFeature AD-Domain-Services ` 
-CreateDnsDelegation:$false ` 
-DatabasePath "C:\Windows\NTDS" ` 
-DomainMode "7" ` 
-DomainName "cadmusgroup.org" ` 
-DomainNetbiosName "sasad" ` 
-ForestMode "7" ` 
-InstallDns:$true ` 
-LogPath "C:\Windows\NTDS" ` 
-NoGlobalCatalog:$false ` 
-NoRebootOnCompletion:$false ` 
-SysvolPath "C:\Windows\SYSVOL" ` 
-Force:$true

EOF

}
resource "aws_instance" "EC2-RDS" {
instance_type = "m5.large"
ami = "${data.aws_ami.amazon_windows_2016.id}"
subnet_id = "${aws_subnet.DMZ-subnet.id}"
tags {
    Name = "SAS-POC-Pub-RDS"
    Workload ="${var.tags_Workload}"
    Creater = "${var.tags_Creater}"
    BusinessOwner ="${var.tags_BusinessOwner}"
    ChargeCode = "${var.tags_ChargeCode}"
    Env = "${var.tags_Env}"
  }
# create security group
vpc_security_group_ids = ["${aws_security_group.sgdmz.id}"] subnet_id = "${aws_subnet.DMZ-subnet.id}"
source_dest_check = false

# The name of our SSH keypair you've created and downloaded
# from the AWS console.
#
# https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs
#
key_name = "${var.key_name}"
 
}