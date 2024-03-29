resource "openstack_compute_keypair_v2" "test_keypair" {
  provider   = openstack.ovh
  name       = var.name_sshkey
  public_key = file(var.file_sshkey)
}

resource "openstack_compute_instance_v2" "test_terraform_instance" {
  name        = var.instance_name
  provider    = openstack.ovh
  image_name  = "Debian 12"
  flavor_name = "b2-7"
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name = "Ext-Net"
  }
}
