# CloudWatch-alarms
implement as-a-code AWS CloudWatch alarms stack using Terraform.
This project involves implementing an AWS CloudWatch alarms stack using Terraform.
The DevOps team manages 30 CloudWatch alarms for each of the 3 regions in which the company runs its services, resulting in a total of 90 alarms.
The goal is to utilize Terraform to define and manage the alarms stack in a consistent and reusable way across regions and environments.
The project involves configuring 3 CloudWatch alarms in each region for dev and prod environments, except for one alarm that should only be provisioned in us-east-1.
The project also involves defining a resource for an SNS topic to be used as an action channel when alarms are triggered. 
Workspaces are used to facilitate provisioning the alarms stack in multiple environments and regions. 
The implementation involves modifying files in the provided directory structure, including adding per-env and per-region variable assignments,
and testing the system in Jenkins and AWS by deploying a change and letting Jenkins provision the new configurations while testing the alarms in action.
