# 30-days-of-terraform

## How to create an azure service principal with contributor access

- Help full link https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html


Specifically, you will need the following 4 pieces of information (aka Azure API keys).

1.  Subscription ID
2.  Tenant ID (aka Directory ID)
3.  Application ID (aka Client ID)
4.  Application Key (aka Client Secret)

### [Obtaining Azure API keys via Azure Portal](https://community.aviatrix.com/t/83hpv1x/how-to-get-azure-api-keys-for-creating-resources-from-the-controller#obtaining-azure-api-keys-via-azure-portal)

You can learn how to obtain Azure API keys via the Azure portal [here](https://docs.aviatrix.com/HowTos/Aviatrix_Account_Azure.html). 

### [Obtaining Azure API keys via Azure CLI](https://community.aviatrix.com/t/83hpv1x/how-to-get-azure-api-keys-for-creating-resources-from-the-controller#obtaining-azure-api-keys-via-azure-cli)

You can also obtain the Azure API keys via the Azure CLI. It may actually be quicker to do so in this manner as opposed to via the Azure Portal. It's a simple 2-step process.

#### [Get Subscription ID and Tenant ID](https://community.aviatrix.com/t/83hpv1x/how-to-get-azure-api-keys-for-creating-resources-from-the-controller#get-subscription-id-and-tenant-id)

From the Azure Portal, click on the first icon immediately to the right of the top search bar. This button will say **Cloud Shell** when hovered over.

![](https://s3-us-west-2.amazonaws.com/media.forumbee.com/i/9154e10f-d97f-4925-bd44-af0aa4347707/h/547.png) 

If you are prompted, be sure to select **Power Shell** instead of **Bash**.

You will get a prompt the first time you run this asking if you are okay with a small monthly cost for Azure Cloud Shell. 

![](https://s3-us-west-2.amazonaws.com/media.forumbee.com/i/d6a393ba-da90-4e39-88e2-ac1cfa065773/h/547.png) 

If you are prompted, click **Create storage**.

Once you are at the Power Shell prompt, type this command to determine your Subscription ID:

```none
PS /home/yourName> Get-AzSubscription
Name       Id                TenantId                             State
----       --                --------                             -----
Azure PAYG xxxx-xx-xxxx-xxxx ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ Enabled
```

The value in the **Id** column is your **Subscription ID**.

The value in the **TenantId** column is your **Tenant ID**.

#### [Get Application ID and Application Key](https://community.aviatrix.com/t/83hpv1x/how-to-get-azure-api-keys-for-creating-resources-from-the-controller#get-application-id-and-application-key)

Next, register an Application in Azure. This command will do that by creating a **Service Principal** with **Contributor** access for onboarding an Azure account into Aviatrix:

```none
az ad sp create-for-rbac --name "Name of your Application" --role="Contributor" --scopes=/subscriptions/xxxx-xx-xxxx-xxxx (replace x's with Subscription ID)
```

You will get output such as this:

```none
PS /home/yourName> az ad sp create-for-rbac --name "Name of your Application" --role="Contributor" --scopes=/subscriptions/xxxx-xx-xxxx-xxxx (replace x's with your Subscription ID)
Creating 'Contributor' role assignment under scope '/subscriptions/xxxx-xx-xxxx-xxxx'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
'name' property in the output is deprecated and will be removed in the future. Use 'appId' instead.
{
  "appId": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "displayName": "Name of your Application",
  "name": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  "password": "YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY",
  "tenant": "ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ"
}
PS /home/yourName>
```

In the output shown on your screen, 

-   **tenant** is the **Tenant ID** (aka Directory ID), which you already knew from the Get-AzSubscription command earlier.
-   **appId** is the **Application ID** (aka Client ID)
-   **password** is the **Application Key** (aka Client Secret). Keep this safe. It will not be displayed again.




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


If you run the plan command on the preceding code, you will see that Terraform wants to create three IAM users, each with a different name ("neo.0", "neo.1", "neo.2"): Terraform will perform the following actions:    # aws_iam_user.example[0] will be created   + resource "aws_iam_user" "example" {       + name          = "neo.0"       (...)     }    # aws_iam_user.example[1] will be created   + resource "aws_iam_user" "example" {       + name          = "neo.1"       (...)     }    # aws_iam_user.example[2] will be created   + resource "aws_iam_user" "example" {       + name          = "neo.2"       (...)     }  Plan: 3 to add, 0 to change, 0 to destroy. Of course, a username like "neo.0" isn’t particularly usable. If you combine count.index with some built-in functions from Terraform, you can customize each “iteration” of the “loop” even more. For example, you could define all of the IAM usernames you want in an input variable in live/global/iam/variables.tf:

For example, consider how tags are set in the aws_autoscaling_group resource: resource "aws_autoscaling_group" "example" {   launch_configuration = aws_launch_configuration.example.name   vpc_zone_identifier  = data.aws_subnets.default.ids   target_group_arns    = [aws_lb_target_group.asg.arn]   health_check_type    = "ELB"    min_size = var.min_size   max_size = var.max_size    tag {     key                 = "Name"     value               = var.cluster_name     propagate_at_launch = true   } }

