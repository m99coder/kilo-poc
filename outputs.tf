output "aws_eu_central_1_ssh_connect" {
  value = "ssh -i ~/.ssh/cloud-key admin@${module.aws_eu_central_1.public_ip}"
}

# output "aws_eu_west_1_ssh_connect" {
#   value = "ssh -i ~/.ssh/cloud-key admin@${module.aws_eu_west_1.public_ip}"
# }

# output "aws_us_east_1_ssh_connect" {
#   value = "ssh -i ~/.ssh/cloud-key admin@${module.aws_us_east_1.public_ip}"
# }

# output "aws_us_west_2_ssh_connect" {
#   value = "ssh -i ~/.ssh/cloud-key admin@${module.aws_us_west_2.public_ip}"
# }

output "az_japaneast_ssh_connect" {
  value = "ssh -i ~/.ssh/cloud-key azureuser@${module.az_japaneast.public_ip}"
}

output "gcp_us_central1_ssh_connect" {
  value = "ssh -i ~/.ssh/cloud-key tf-serviceaccount@${module.gcp_us_central1.public_ip}"
}
