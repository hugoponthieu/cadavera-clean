#!/bin/bash
mv ovhInstance/etc/rancher/k3s/k3s.yaml ./k3s.yaml
url=$(cat k3s_url)
rm k3s_url
rm -r ovhInstance
kubectl --kubeconfig k3s.yaml config set-cluster default --server="$url"
mv k3s.yaml ../appYAML/k3s.yaml