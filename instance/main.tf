module "upServer" {
  source = "./upServer"
  name_sshkey = "Name you want to key to take in your ovh account"
  file_sshkey = "Path to a local public key"
  application_key = "Generate app key"
  application_secret = "Generate app secret"
  consumer_key = "Generate consumer key"
  instance_name = "Name of the instance that the module will create"
}