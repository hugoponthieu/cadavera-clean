resource "openstack_compute_keypair_v2" "test_keypair" {
  provider   = openstack.ovh
  name       = var.name_sshkey
  public_key = file(var.file_sshkey)
}

resource "openstack_compute_instance_v2" "test_terraform_instance" {
  for_each    = toset(var.instances)
  name        = each.key
  provider    = openstack.ovh
  image_name  = "Debian 12"
  flavor_name = "b3-8"
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net"
  }
}
