# Cadavera

This documentation has been written to be followed with eyes closed (almost). Try to not move any file in order to not corrupt the installation. This documentation should work for almost all linux distros. All actions in this documentation do NOT require to be logged as root.

### Requirements

To follow the installation you must have: 
	- Openstack accesses:
		1) [Configure OVH user](https://help.ovhcloud.com/csm/fr-public-cloud-compute-horizon?id=kb_article_view&sysparm_article=KB0050895)
		2) [Install openstack-client](https://help.ovhcloud.com/csm/fr-public-cloud-compute-prepare-openstack-api-environment?id=kb_article_view&sysparm_article=KB0050995)
		3) [Provide env variable](https://help.ovhcloud.com/csm/fr-public-cloud-compute-set-openstack-environment-variables?id=kb_article_view&sysparm_article=KB0050935) 
	- [Terraform](https://developer.hashicorp.com/terraform/install)
	- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
	- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
	- Having an ssh key ready to be used

First of all clone the project:
```bash
git clone https://github.com/hugoponthieu/cadavera.git
```

Enter the project:
```bash
cd cadavera
```

If you fill requirements you should have download the `openrc.sh`
Source the file openrc.sh file: 
```bash
source path/to/openrc.sh
```

## Provide infrastructure

Then let's setup the infrastructure:
```bash
cd instance
```

Once the configuration is done you should fill `main.tf`
You must provide:
- Path to a local ssh key
- Its name (choose anything you want)
- Gather application key , application secret and consumers key from [here](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

```yaml 
module "upServer" {
  source             = "./upServer"
  name_sshkey        = "Name you want to key to take in your ovh account"
  file_sshkey        = "Path to a local public key"
  application_key    = "Generate app key"
  application_secret = "Generate app secret"
  consumer_key       = "Generate consumer key"
  instance_name      = "Name of the instance that the module will create"
}
```

As you are in the file  `` instance/ ``  you can now run:
```bash
terraform init
```

Then: 
```bash
terraform apply
```

If everything went as planned you should have this at the end of the execution:
```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```

## Create Kubernetes cluster
You can now enter: 
```bash
cd ../k3s-ansible
```

Then run: 
```bash
ansible-playbook playbook/site.yml -i inventory
```

After a lot of logs (too much) your cluster should be setup and functional. Let's now provide an access to this cluster
## Setup the access

Now let's configure the freshly created instance. So you can run:
```bash
cd ../setup
```

Launch the Ansible playbook with:
```bash
ansible-playbook -i inventory k3s-install.yaml
```

You can now run to finish the setup:
```bash
./setup_local.sh
```

You are now entering the last part of the documentation. You should be able to use the cadavre exquis very soon (almost).

## Deploy the app

```bash
cd ../appYAML
```

Everything is now setup to access the Kubernetes cluster you've juste build. You can launch the configuration with: 
```bash
kubectl apply --kubeconfig=k3s.yaml -f . 
```