module "upServer" {
  source             = "./upServer"
  name_sshkey        = "hugoSSHkey"
  file_sshkey        = "~/.ssh/id_rsa.pub"
  application_key    = "d4276d7de1f4a2ef"
  application_secret = "749f012277db5fb5baad53cc2ccee43e"
  consumer_key       = "c61a14e4032262269a32f7259deb5772"
  instances      = var.instances
}
