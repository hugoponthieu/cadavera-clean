#!/bin/bash
mv controlPlane/etc/rancher/k3s/k3s.yaml ./k3s.yaml
url=$(cat k3s_url)
# rm k3s_url
# rm -r ovhInstance
kubectl --kubeconfig k3s.yaml config set-cluster default --server="$url"
mv k3s.yaml ../appYAML/k3s.yaml


kubeconfig_file="../appYAML/k3s.yaml"

domain_name="escalope.fr"

# Extract server address from kubeconfig
server_address=$(grep server $kubeconfig_file | awk '{print $2}' | head -n1)

# Extract only IPv4 address
ipv4_address=$(echo "$server_address" | sed -E 's#https?://([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*#\1#')

# Check if IPv4 address is not empty
if [ -n "$ipv4_address" ]; then
    # Append IPv4 address and domain name to /etc/hosts
    echo "$ipv4_address $domain_name" | sudo tee -a /etc/hosts >/dev/null
    echo "IPv4 address added to /etc/hosts"
else
    echo "Failed to extract IPv4 address from kubeconfig"
fi
