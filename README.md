# AWS CloudWatch Alarms using Terraform

This project implements an AWS CloudWatch alarms stack using Terraform. The DevOps team manages 30 CloudWatch alarms for each of the 3 regions in which the company runs its services, resulting in a total of 90 alarms. The goal is to utilize Terraform to define and manage the alarms stack in a consistent and reusable way across regions and environments.

## Features

- Configures 3 CloudWatch alarms in each region for dev and prod environments
- Defines a resource for an SNS topic to be used as an action channel when alarms are triggered
- Uses Workspaces to facilitate provisioning the alarms stack in multiple environments and regions

## Directory Structure

```
tf_alarm/
├── alarms.Jenkinsfile
├── environments
│   ├── dev.tfvars
│   └── prod.tfvars
├── main.tf
├── outputs.tf
├── regions
│   ├── eu-central-1-prod.tfvars
│   ├── us-east-1-dev.tfvars
│   ├── us-east-1-prod.tfvars
│   └── us-west-1-prod.tfvars
└── variables.tf
```

- `main.tf`: contains configurations of 3 CloudWatch alarms, as well as the Terraform block with the relevant provider and an S3 backend
- `variables.tf` and `outputs.tf`: contain variable definitions and outputs
- `environments` directory: contains .tfvars files with per-env variable assignments
- `regions` directory: contains .tfvars files with per-region variable assignments
- `alarms.Jenkinsfile`: an almost ready-to-use Jenkinsfile to integrate the alarms pipeline in your Jenkins server

## Diagram
<img src="https://github.com/SharonLeviDevops/CloudWatch-alarms/blob/main/Diagram.jpg" alt="Alt text">
## Usage

1. Clone the repository:

   ```
   git clone https://github.com/<username>/<repository>.git
   ```

2. Modify the .tfvars files in the `environments` and `regions` directories with the relevant values for your environment and regions.

3. Run the Terraform commands:

   ```
   terraform init
   terraform workspace new <workspace-name>
   terraform apply -var-file=environments/<env>.tfvars -var-file=regions/<region>.tfvars
   ```

4. Verify that the CloudWatch alarms and SNS topic have been created in your AWS account.

5. Test the system by deploying a change and letting Jenkins provision the new configurations while testing the alarms in action.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Terraform documentation](https://www.terraform.io/docs/index.html)
- [AWS CloudWatch documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)
