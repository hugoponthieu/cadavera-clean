# cadavera

This documentation has been written to be followed with eyes closed (almost). Try to not move any file in order to not corrupt the installation. This documentation should work for almost all linux distros. All actions in this documention do NOT require to be logged as root

First of all clone the project:

```bash
git clone https://github.com/hugoponthieu/cadavera.git
```

Enter the project:

```bash
cd cadavera
```

Then let's setup the infrastructure:

```bash
cd instance
```

For this part you'll need to have an access to an OVH account using openstack. If you have any problem you check [this documentation](https://help.ovhcloud.com/csm/en-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050797) to setup correctly your access.

At one point you'll have to gather ``application_key`` , ``application_secret`` and ``consumer_key`` . There is a placeholder for these keys directly in ``/cadavera/instance/main.tf``

Then when the access is setup you should be able to do that:

```bash
openstack server list
```

The result of that command should look like this:
![[Pasted image 20240324114940.png]]
If you have no server nothing will display (it's normal). Do not continue to execute this documentation if this condition is not checked.

As you are in the file  `` instance/ ``  you can now run:

```bash
terraform init
```

If terraform is not installed use [this](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Then:

```bash
terraform apply
```

If everything went as planned you should have this at the end of the execution:

```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

Now let's configure the freshly created instance. So you can run:

```bash
cd ../setup
```

Launch the [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) playbook with:

```bash
ansible-playbook -i inventory k3s-install.yaml
```

As this is the first time your are connecting to the instance the ansible execution could ask you:

```
The authenticity of host '57.129.29.90 (57.129.29.90)' can't be established.
ED25519 key fingerprint is SHA256:nLag5lCt+CMUPQMDY/HbS8rzwFogrcTuHqlOZROMA8w.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? 
```

It is mandatory to type "yes" so do it :)

A kubernetes cluster has been installed on the instance and the ansible provided accesses to that cluster.

You can now run to finish the setup:

```bash
./setup_local.sh
```

You can now move to the YAML part

```bash
cd ../appYAML
```

You are now entering the last part of the documentation. You should be able to use the cadavre exquis very soon (almost).

Everything is now setup to access the kubernetes cluster you've juste build. You can launch the configuration with:

```bash
kubectl apply --kubeconfig=k3s.yaml -f . 
```

You also need to add the DNS name to the /etc/hosts

```bash
sudo nano /etc/hosts
```

On the last line write

```bash
51.68.164.124 escalope.fr
```
