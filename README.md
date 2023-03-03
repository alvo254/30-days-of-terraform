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

Deploying a Load BalancerAt this point, you can deploy your ASG, but you’ll have a small problem:
you now have multiple servers, each with its own IP address, but you
typically want to give your end users only a single IP to use. One way to
solve this problem is to deploy a load balancer to distribute traffic across
your servers and to give all your users the IP (actually, the DNS name) of
the load balancer. Creating a load balancer that is highly available and
scalable is a lot of work. Once again, you can let AWS take care of it for
you, this time by using Amazon’s Elastic Load Balancer (ELB) service


Loops with the count Parameter In Chapter 2, you created an AWS Identity and Access Management (IAM) user by clicking around the Console. Now that you have this user, you can create and manage all future IAM users with Terraform. Consider the following Terraform code, which should live in live/global/iam/main.tf: provider "aws" { region = "us-east-2" } resource "aws_iam_user" "example" { name = "neo" } This code uses the aws_iam_user resource to create a single new IAM user. What if you want to create three IAM users? In a general-purpose programming language, you’d probably use a for-loop:





