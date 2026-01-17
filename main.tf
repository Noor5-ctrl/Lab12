provider "aws" {
  region = "me-central-1"
}

# 1. Base VPC Resource
resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = { Name = "${var.env_prefix}-vpc" }
}

# 2. Subnet Module Call
module "myapp-subnet" {
  source                 = "./modules/subnet"
  vpc_id                 = aws_vpc.myapp_vpc.id
  subnet_cidr_block      = var.subnet_cidr_block
  availability_zone      = var.availability_zone
  env_prefix             = var.env_prefix
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id
}

# 3. Webserver Module Call - Nginx Proxy Server (Instance Suffix 0)
module "myapp-webserver" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  public_key        = var.public_key
  my_ip             = local.my_ip
  vpc_id            = aws_vpc.myapp_vpc.id
  subnet_id         = module.myapp-subnet.subnet.id
  script_path       = "./entry-script.sh"
  instance_suffix   = "0"
}

# 4. Webserver Module Call - Apache Backend Server (Instance Suffix 1)
module "myapp-web-1" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  public_key        = var.public_key
  my_ip             = local.my_ip
  vpc_id            = aws_vpc.myapp_vpc.id
  subnet_id         = module.myapp-subnet.subnet.id
  script_path       = "./apache.sh"
  instance_suffix   = "1"
}
# 5. Webserver Module Call - Second Apache Backend (Instance Suffix 2)
module "myapp-web-2" {
  source            = "./modules/webserver"
  env_prefix        = var.env_prefix
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  public_key        = var.public_key
  my_ip             = local.my_ip
  vpc_id            = aws_vpc.myapp_vpc.id
  subnet_id         = module.myapp-subnet.subnet.id
  script_path       = "./apache.sh"
  instance_suffix   = "2"
}