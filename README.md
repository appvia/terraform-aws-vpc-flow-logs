![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# Terraform AWS VPC Flow Logs

## Description

A module to enable VPC flow logs on an aws vpc

## Usage

Add example usage here

```hcl
module "example" {
  source  = "appvia/terraform-aws-vpc-flow-logs/aws"
  version = "0.0.1"

  name   = "example-vpc-flow-logs"
  vpc_id = "vpc-0123456789abcdef"
}
```

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name used for the cloudwatch group and role | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to enable flow logs for | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain flow logs | `number` | `365` | no |
| <a name="input_traffic_type"></a> [traffic\_type](#input\_traffic\_type) | Type of traffic to capture. Valid values: ACCEPT,REJECT, ALL | `string` | `"ALL"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
