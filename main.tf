provider "aws" {
  region     = "eu-north-1"
  access_key = ""
  secret_key = ""
}


resource "aws_instance" "test" {
  availability_zone      = "eu-north-1a"
  ami                    = "ami-0989fb15ce71ba39e"
  instance_type          = "t3.micro"
  key_name               = "kuzma"
  vpc_security_group_ids = [aws_security_group.default.id]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 10
    volume_type = "standard"
    tags = {
      Name = "root-disk"
    }
  }

  user_data = file("files/install.sh")

  tags = {
    Name = "EC2-instance"
  }
}
resource "aws_iam_user" "example" {
  name = "example-user"  # Provide a unique name for the IAM user

  tags = {
    Name = "Example User"
  }
}

resource "aws_iam_access_key" "example" {
  user = aws_iam_user.example.name
}
resource "aws_security_group" "default" {
  name        = "DefaultTerraformSG"
  description = "Allow 22, 80, 443 inbound traffic"

  dynamic "ingress" {
    for_each = ["22", "80", "443", "8080", "8000", "10050", "10501", "9999"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_user" "my_user" {
  name = "my-user"
}

// Attach IAM user to the group
resource "aws_iam_group_membership" "my_membership" {
  name  = "my-membership"
  users = [aws_iam_user.my_user.name]
  group = aws_iam_group.my_group.name
}

// Create IAM group
resource "aws_iam_group" "my_group" {
  name = "my-group"
}

// Create IAM group policy
resource "aws_iam_policy" "my_group_policy" {
  name        = "my-group-policy"
  description = "My IAM group policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })
}

// Attach policy to the IAM group
resource "aws_iam_group_policy_attachment" "my_attachment" {
  group      = aws_iam_group.my_group.name
  policy_arn = aws_iam_policy.my_group_policy.arn
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "kuzma343bucket2"

  tags = {
    Name        = "My Terraform Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "example_object_folder" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "kuzma/"

  content = ""  # Порожній рядок для створення папки

  tags = {
    Name        = "Kuzma Folder"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_object" "example_object_image" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "kuzma/ryan-r_-bloodyf8-2.jpg"

source = "https://raw.githubusercontent.com/kuzma343/kuzmatest/main/files/123.txt?token=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"


  tags = {
    Name        = "Ryan Image"
    Environment = "Production"
  }
}
