# 3-Tire-Architecture-Aws-Infrastructer-

## README: Terraform Configuration for EC2 Instances

### Overview

This Terraform configuration creates two EC2 instances on AWS: a public instance and a private instance. The public instance is accessible from the internet, while the private instance is only accessible from within the VPC.

### Requirements

* An AWS account with necessary permissions.
* Terraform installed on your local machine.

### Configuration

**1. Provider:**
- The `provider "aws"` block configures the AWS provider with the specified region and credentials.

**2. VPC and Subnets:**
- The `aws_vpc` resource creates a VPC with a CIDR block of `10.0.0.0/16`.
- The `aws_subnet` resources create public and private subnets within the VPC.

**3. Security Groups:**
- The `aws_security_group` resources define security groups for the public and private instances.
    - The public security group allows SSH (port 22) and HTTP (port 80) access from anywhere.
    - The private security group currently allows SSH access from anywhere. Adjust this based on your security requirements.

**4. EC2 Instances:**
- The `aws_instance` resources create the public and private EC2 instances.
    - The public instance is associated with the public subnet and uses the public security group.
    - The private instance is associated with the private subnet and uses the private security group.

### Usage

1. **Replace placeholders:** Replace the placeholders for your AWS credentials and AMI ID with your actual values.
2. **Initialize Terraform:** Run `terraform init` in your project directory.
3. **Plan and Apply:** Run `terraform plan` to preview the changes and `terraform apply` to create the infrastructure.

### Customization

- **AMI:** Modify the `ami` property to use a different AMI.
- **Instance Type:** Adjust the `instance_type` to choose a different instance type.
- **Security Groups:** Modify the security groups to allow or restrict access to specific ports and IP addresses.
- **Tags:** Add or remove tags to organize your instances.

### Additional Notes

- This configuration provides a basic example. You may need to adjust it based on your specific requirements and security best practices.
- Consider using IAM roles to manage access to your instances.
- Implement monitoring and logging to track the health and performance of your EC2 instances.
