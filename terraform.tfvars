ami_id        = "ami-08e5424edfe926b43"  # Ubuntu Server 22.04 LTS in ap-south-1 (Mumbai)
instance_type = "t2.micro"

s3_bucket_name      = "my-terraform-state-bucket"  
dynamodb_table_name = "my-terraform-locks"          
environment         = "dev"
