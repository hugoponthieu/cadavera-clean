data "template_file" "ansible_inventory" {
  template = <<EOF
---
k3s_cluster:
  children:
    server:
      hosts:
        ${openstack_compute_instance_v2.test_terraform_instance[var.instances[0]].access_ip_v4}:
    agent:
      hosts:
        ${openstack_compute_instance_v2.test_terraform_instance[var.instances[1]].access_ip_v4}:
        ${openstack_compute_instance_v2.test_terraform_instance[var.instances[2]].access_ip_v4}:

  # Required Vars
  vars:
    ansible_port: 22
    ansible_user: debian
    k3s_version: v1.26.9+k3s1
    token: "mytoken"  # Use ansible vault if you want to keep it secret
    api_endpoint: "{{ hostvars[groups['server'][0]]['ansible_host'] | default(groups['server'][0]) }}"
    extra_server_args: ""
    extra_agent_args: ""

  # Optional vars
    # cluster_context: k3s-ansible
    # api_port: 6443
    # k3s_server_location: /var/lib/rancher/k3s
    # systemd_dir: /etc/systemd/system
    # extra_service_envs: [ 'ENV_VAR1=VALUE1', 'ENV_VAR2=VALUE2' ]
    # Manifests or Airgap should be either full paths or relative to the playbook directory.
    # List of locally available manifests to apply to the cluster, useful for PVCs or Traefik modifications.
    # extra_manifests: [ '/path/to/manifest1.yaml', '/path/to/manifest2.yaml' ]
    airgap_dir: ./my-airgap
    # user_kubectl: true, by default kubectl is symlinked and configured for use by ansible_user. Set to false to only kubectl via root user.
    # server_config_yaml:  |
    #   This is now an inner yaml file. Maintain the indentation.
    #   YAML here will be placed as the content of /etc/rancher/k3s/config.yaml
    #   See https://docs.k3s.io/installation/configuration#configuration-file
    # registries_config_yaml:  |
    #   Containerd can be configured to connect to private registries and use them to pull images as needed by the kubelet.
    #   YAML here will be placed as the content of /etc/rancher/k3s/registries.yaml
    #   See https://docs.k3s.io/installation/private-registry
EOF
}

resource "local_file" "ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "../k3s-ansible/inventory.yaml"
}
