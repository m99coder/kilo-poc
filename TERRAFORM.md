# Terraform

## General

* <https://developer.hashicorp.com/terraform/language>
* <https://www.sammeechward.com/variables-and-outputs-in-terraform>
* <https://www.sammeechward.com/terraform-modules>

```tf
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```

* _Blocks_ are containers for other content and usually represent the configuration of some kind of object, like a resource. Blocks have a _block type_, can have zero or more _labels_, and have a _body_ that contains any number of arguments and nested blocks. Most of Terraform’s features are controlled by top-level blocks in a configuration file.
* _Arguments_ assign a value to a name. They appear within blocks.
* _Expressions_ represent a value, either literally or by referencing and combining other values. They appear as values for arguments, or within other expressions.

Terraform always runs in the context of a single _root module_. A complete _Terraform configuration_ consists of a root module and the tree of child modules (which includes the modules called by the root module, any modules called by those modules, etc.). In Terraform CLI, the root module is the working directory where Terraform is invoked.

### Dependency Lock File

The dependency lock file is a file that belongs to the configuration as a whole, rather than to each separate module in the configuration. For that reason Terraform creates it and expects to find it in your current working directory when you run Terraform, which is also the directory containing the `.tf` files for the root module of your configuration.

The lock file is always named `.terraform.lock.hcl`, and this name is intended to signify that it is a lock file for various items that Terraform caches in the `.terraform` subdirectory of your working directory.

### Identifiers

Argument names, block type names, and the names of most Terraform-specific constructs like resources, input variables, etc. are all _identifiers_.

Identifiers can contain letters, digits, underscores (`_`), and hyphens (`-`). The first character of an identifier must not be a digit, to avoid ambiguity with literal numbers.

### Comments

The `#` single-line comment style is the default comment style and should be used in most cases. An alternative to `#` is `//` whereas `/*` and `*/` are start and end delimiters for a comment that might span over multiple lines.

### Data Sources

Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

### Variables and Outputs in Terraform

> [Standard Module Structure](https://www.terraform.io/docs/language/modules/develop/structure.html)

* every Terraform configuration has at least one module, known as its root module
* when you create a new terraform module, you should create a new directory with at least the following three files inside:
  * `main.tf`: The primary entrypoint to the entire configuration
  * `variables.tf`: Any input variables for the module (this allows the user running terraform to easily customize the configuration)
  * `outputs.tf`: Any outputs from the module (this allows the user running terraform to easily get data about any resources)
* `terraform.tfvars` is a variable definitions file where we can define values for any input variables

### Terraform Modules

```plain
.
├── main.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
└── variables.tf

4 directories, 9 files
```

`./modules/vpc/variables.tf`

```hcl
variable "vpc_cidr" {
  description = "CIDR block for the entire VPC"
  type        = string
}

variable "public_sub_1_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_sub_1_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}
```

`./modules/vpc/main.tf`

```hcl
resource "aws_vpc" "some_custom_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.public_sub_1_cidr
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = var.private_sub_1_cidr
}
```

`./modules/ec2/variables.tf`

```hcl
variable "public_sg_id" {
  description = "ID of the security group for the public subnet"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}
```

`./modules/ec2/outputs.tf`

```hcl
output "public_ip" {
  value = aws_instance.web_instance.public_ip
}
```

`./modules/ec2/main.tf`

```hcl
data "aws_ami" "amz_linux_2" {
  most_recent = true
  name_regex  = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
  owners      = ["amazon"]
}

resource "aws_instance" "web_instance" {
  ami           = data.aws_ami.amz_linux_2.id
  instance_type = "t2.nano"

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex
  amazon-linux-extras install nginx1 -y
  systemctl enable nginx
  systemctl start nginx
  EOF
}
```

`./main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

module "my_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  public_sub_1_cidr  = "10.0.1.0/24"
  private_sub_1_cidr = "10.0.2.0/24"
}

module "my_ec2" {
  source = "./modules/ec2"

  public_subnet_id = module.my_vpc.public_subnet_id
  public_sg_id     = module.my_vpc.public_sg_id
}
```

`./outputs.tf`

```hcl
output "public_ip" {
  value = module.my_ec2.public_ip
}
```

`./variables.tf`

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}
```

## AWS

* <https://developer.hashicorp.com/terraform/tutorials/aws-get-started>
* <https://www.sammeechward.com/playlists/cloud-computing>
* <https://www.sammeechward.com/cloud-init-and-terraform-with-aws>
* <https://www.sammeechward.com/intro-to-terraform-with-aws>
* <https://www.sammeechward.com/aws-vpc-and-subnets-for-beginners>
* <https://www.sammeechward.com/terraform-vpc-subnets-ec2-and-more>
* <https://www.sammeechward.com/setup-a-nat-gateway-on-aws>
* <https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html>

### Cloud-init and Terraform with AWS

* Cloud-init is a piece of software that configures a cloud VM when it’s first initialized

`server.yml`

```yaml
#cloud-config
write_files:
  - path: /run/myserver/index.html
    owner: root:root
    permissions: "0644"
    content: "<h1>${header}</h1>"
runcmd:
  - amazon-linux-extras install -y nginx1
  - mv /run/myserver/index.html /usr/share/nginx/html/index.html
  - systemctl enable --no-block nginx
  - systemctl start --no-block nginx
```

`main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = "us-west-1"
}

resource "aws_security_group" "server_sg" {
  name = "Load Balancer Security Group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "cloudinit_config" "server_config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/server.yml", {
      header: aws_security_group.server_sg.id
    })
  }
}

resource "aws_instance" "server_instance1" {
  ami           = "ami-03ab7423a204da002"
  instance_type = "t2.micro"

  key_name = "CaliKey"

  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  user_data                   = data.cloudinit_config.server_config.rendered
  associate_public_ip_address = true
}
```

### VPCs, Subnets and Security Groups

* <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc>

VPC is a private network

* with private IP address range (see [CIDR](https://cidr.xyz/))
* within private IP range subnets are created
* one VPC per region, one subnet per availability zone
* resources (like EC2 instances) are then deployed to these subnets
* each resource can have assigned a private IP address
* by default all resources within a VPC can communicate with each other
* by default a VPC is completely private

Internet Gateways

* can be attached to subnets which makes them public and accessible through the public internet
* examples are resources like load balancers
* requires route table (manages where traffic goes)

NAT Gateway

* to allow connections out of the private subnet without allowing public access

[Private Address Ranges](https://www.ibm.com/docs/en/networkmanager/4.2.0?topic=translation-private-address-ranges)

* Class A: 10.0.0.0 to 10.255.255.255 – CIDR `10.0.0.0/8` (netmask `255.0.0.0`), 24-bit block
* Class B: 172.16.0.0 to 172.31.255.155 – CIDR `172.16.0.0/12` (netmask `255.240.0.0`), 20-bit block
* Class C: 192.168.0.0 to 192.168.255.255 – CIDR `192.168.0.0/16` (netmask `255.255.0.0`), 16-bit block

CIDR

* the decimal value that comes after the slash is the number of bits consisting of the routing prefix
* designates how many available addresses are in the block (as the prefix is preserved)
* for routing mask values <= 30, first and last IPs are base and broadcast addresses and are unusable
* in AWS 10.0.0.0/16 is the minimum number to be used for VPCs
* 65,536 private IP addresses from 10.0.0.1 to 10.0.255.254

### VPC and EC2 instance

When setting up a new VPC to deploy EC2 instances, one usually follows these basic steps:

1. Create a VPC
2. Create subnets for different parts of the infrastructure
3. Attach an internet gateway to the VPC
4. Create a route table for a public subnet
5. Create security groups to allow specific traffic
6. Create EC2 instances on the subnets

#### Create a VPC

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

```hcl
resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Some Custom VPC"
  }
}
```

This will setup a new VPC with the CIDR block `10.0.0.0/16` and the name `Some Custom VPC`. We can reference the VPC locally in the `.tf` file using `some_custom_vpc`.

#### Create subnets for different parts of the infrastructure

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

```hcl
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "1a"

  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "1a"

  tags = {
    Name = "Some Private Subnet"
  }
}
```

This will create two new subnets in AZ `1a` with the CIDR blocks `10.0.1.0/24` and `10.0.2.0/24`. We need to use the VPC ID from the previous step.

#### Attach an internet gateway to the VPC

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

```hcl
resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "Some Internet Gateway"
  }
}
```

This creates an internet gateway and attaches it to the custom VPC. Now we need a route table to handle routing to one or more of the subnets.

#### Create a route table for a public subnet

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)

```hcl
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}
```

This will create a new route table on the custom VPC. We can also specify the routes to route internet traffic through the gateway. So the route table and internet gateway are setup on the VPC, now we just need to assiociate any public subnets with the route table.

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)

```hcl
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
```

Now `some_public_subnet` is accessible over the public internet.

#### Create security groups to allow specific traffic

Before we setup a new EC2 instance on the public subnet, we need to create a security group that allows internet traffic on port 80 and 22. We’ll also allow outgoing traffic on all ports.

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

```hcl
resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

#### Create EC2 instances on the subnets

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)

Time to deploy an EC2 instance. If you already have an SSH keypair setup, you can just use that and skip the next step. If you haven’t, or if you want to setup a new SSH key for this instance, run the following command using the AWS CLI.

```shell
# aws ec2 describe-key-pairs --key-name marco-ctf
# aws ec2 import-key-pair --key-name MyKeyPair --public-key-material fileb://~/.ssh/my-key.pub
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ~/.ssh/MyKeyPair.pem
chmod 400  ~/.ssh/MyKeyPair.pem
```

This will generate a new keypair and store the private key on your machine at `~/.ssh/MyKeyPair.pem`.

> [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)

```hcl
resource "aws_instance" "web_instance" {
  ami           = "ami-0533f2ba8a1995cf9"
  instance_type = "t2.micro"
  key_name      = "MyKeyPair"

  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    "Name": "Web Instance"
  }
}
```

This sets up a new Amazon Linux 2 EC2 instance.

#### Script

Use the following commands to

* `terraform init`: Setup a new terraform project
* `terraform apply`: Setup the infrastructure as it’s defined in the `.tf` file
* `terraform destroy`: Tear down everything that terraform created
* `terraform state list`: Show everything that was created by terraform
* `terraform state show aws_instance.web_instance`: Show the details about the EC2 instance that was deployed

### Setup a NAT Gateway on AWS

* allows resources on a private subnet to access things over the public internet while still remaining private
* stands for Network Address Translation
* has a public IP address and can be used by private resources as a middle man
* works quite the same way like a router in the home network
* must go on a public subnet
* forward any traffic that is not already routed from the private subnet to the NAT gateway using the route table
* very expensive and not required to allow traffic within the same VPC
* when using it, don’t forget to delete the NAT gateway, the respective entry in the route table and the elastic IP

### VPC Gateway Endpoints

* pay attention to the type: interface endpoints will cost money, whereas gateway endpoints will not
* only S3 and Dynamo DB can be used with gateway endpoints at the moment

## GCP

* <https://jansutris10.medium.com/install-google-cloud-sdk-using-homebrew-on-mac-2952c9c7b5a1>
* <https://binx.io/2022/01/07/how-to-create-a-vm-with-ssh-enabled-on-gcp/>
* <https://www.middlewareinventory.com/blog/create-linux-vm-in-gcp-with-terraform-remote-exec/>

### Setup Google Cloud SDK

```shell
brew install google-cloud-sdk

# for ~/.zshrc
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

gcloud version
```

### Setup project & service account

```shell
# authenticate
gcloud auth login
gcloud projects list

# create project `kilo-poc`
gcloud projects create kilo-poc
gcloud config set project kilo-poc

# create service account
gcloud iam service-accounts create tf-serviceaccount --description="Service account for terraform" --display-name="terraform_service_account"

# create keys
gcloud iam service-accounts keys create ./gcp.json --iam-account tf-serviceaccount@kilo-poc.iam.gserviceaccount.com
```

Additional roles required:

* Compute Engine > Compute Admin (`roles/compute.admin`)
* Compute Engine > Compute Network Admin (`roles/compute.networkAdmin`)

```shell
gcloud projects add-iam-policy-binding kilo-poc --member=serviceAccount:tf-serviceaccount@kilo-poc.iam.gserviceaccount.com --role=roles/compute.admin
gcloud projects add-iam-policy-binding kilo-poc --member=serviceAccount:tf-serviceaccount@kilo-poc.iam.gserviceaccount.com --role=roles/compute.networkAdmin
```

### Enabling Compute Engine API

<https://console.developers.google.com/apis/library/compute.googleapis.com?project=223235724038>

## Azure

```shell
# install CLI
brew install azure-cli

# authenticate
az login
az account set --subscription "9b6ad402-a6ec-48b9-b418-879aec8104f3"

# create Active Directory service principal
# this command provides credentials as response
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/9b6ad402-a6ec-48b9-b418-879aec8104f3"

# get all locations
az account list-locations -o table # japaneast (Tokyo)

# get all Debian 11 images
az vm image list --all --publisher Debian --offer debian-11
```
