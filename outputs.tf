output "webserver_public_ip" {
  value = module.myapp-webserver.aws_instance.public_ip
}

output "aws_web-1_public_ip" {
  value = module.myapp-web-1.aws_instance.public_ip
}
output "aws_web-2_public_ip" {
  value = module.myapp-web-2.aws_instance.public_ip
}