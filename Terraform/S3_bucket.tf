resource "aws_s3_bucket" "b" {
  bucket = "sas-poc-bucket"
  acl    = "private"
  tags {
    Name = "SAS-POC-S3-Bucket"
    Workload ="${var.tags_Workload}"
    Creater = "${var.tags_Creater}"
    BusinessOwner ="${var.tags_BusinessOwner}"
    ChargeCode = "${var.tags_ChargeCode}"
    Env = "${var.tags_Env}"
  }
}
resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.b.id}"
  policy =<<POLICY
{
    "Id": "Policy1540216481420",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1540216479396",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::sas-poc-bucket/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "47.36.21.43",
                        "108.227.71.20",
                        "63.239.38.226",
                        "63.156.199.82",
                        "146.115.5.198",
                        "67.135.37.137",
                        "173.12.181.101",
                        "96.86.42.189",
                        "172.74.193.72"
                    ]
                }
            },
            "Principal": "*"
        }
    ]
}
POLICY
}