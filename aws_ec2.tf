#Amazon Linux2のAMIベースにt2.microのEC2を作成
resource "aws_instance" "example" {
    ami = "ami-09ebacdc178ae23b7" #Amazon Linux2
    instance_type = "t2.micro"
}


