# 30-days-of-terraform

resource "aws_autoscaling_group" "example" {
launch_configuration = aws_launch_configuration.example.name
min_size = 2
max_size = 10
tag {
key
= "Name"
value
= "terraform-asg-example"
propagate_at_launch = true
}
}

resource "aws_launch_configuration" "example" {
image_id
= "ami-0fb653ca2d3203ac1"
instance_type = "t2.micro"
security_groups = [aws_security_group.instance.id]
user_data = <<-EOF
#!/bin/bash
echo "Hello, World" > index.xhtml
nohup busybox httpd -f -p ${var.server_port} &
EOF
# Required when using a launch configuration with an auto scaling group.
lifecycle {
create_before_destroy = true
}
}