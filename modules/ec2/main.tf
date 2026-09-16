# ============================================================
# IAM Role for AWS Systems Manager (SSM)
# ============================================================

resource "aws_iam_role" "ssm_role" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-ssm-role"
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project_name}-${var.environment}-ec2-ssm-profile"

  role = aws_iam_role.ssm_role.name
}


# ============================================================
# Web EC2 Instance
# ============================================================

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.web_security_group_id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y httpd

              systemctl enable httpd
              systemctl start httpd

              echo "<h1>Micro-Segmented Cloud Network - Web Tier</h1>" > /var/www/html/index.html
              echo "<p>Web Server is running successfully.</p>" >> /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-web"
    Tier        = "Web"
    Project     = var.project_name
    Environment = var.environment
  }
}


# ============================================================
# Application EC2 Instances
# ============================================================

resource "aws_instance" "app" {
  count = length(var.private_app_subnet_ids)

  ami           = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  subnet_id              = var.private_app_subnet_ids[count.index]
  vpc_security_group_ids = [var.app_security_group_id]

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y
              dnf install -y python3

              mkdir -p /opt/app

              cat <<'APP' > /opt/app/app.py
              from http.server import BaseHTTPRequestHandler, HTTPServer

              class Handler(BaseHTTPRequestHandler):
                  def do_GET(self):
                      self.send_response(200)
                      self.send_header("Content-type", "text/html")
                      self.end_headers()
                      self.wfile.write(
                          b"<h1>Application Tier</h1><p>App server is running.</p>"
                      )

              server = HTTPServer(("0.0.0.0", 8080), Handler)
              server.serve_forever()
              APP

              nohup python3 /opt/app/app.py > /var/log/app.log 2>&1 &
              EOF

  tags = {
    Name        = "${var.project_name}-${var.environment}-app-${count.index + 1}"
    Tier        = "Application"
    Project     = var.project_name
    Environment = var.environment
  }
}

 
# ============================================================
# Suricata IDS EC2 Instance
# ============================================================

resource "aws_instance" "ids" {
  ami           = var.ami_id
  instance_type = var.ids_instance_type
  key_name      = "WorkshopKeyPair"

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.web_security_group_id]

  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-suricata-ids"
    Tier        = "Security"
    Project     = var.project_name
    Environment = var.environment
  }
}
