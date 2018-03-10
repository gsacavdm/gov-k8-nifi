#!/bin/bash

# Install Nginx
helm install stable/nginx-ingress --name ssl-ingress --set rbac.create=true

# Install Lets Encrypt
helm install --name lego --set config.LEGO_EMAIL=janedoe@contoso.com --set config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory stable/kube-lego --set rbac.create=true

# Get external facing IP for ingress controller
kubectl get service ssl-ingress-nginx-ingress-controller 

# Add a DNS entry with your domain provider (e.g GoDaddy)
# *** this is done via web browser ***

# Create Kubernetes ingress (sets up both nginx ingress and lego ingress)
kubectl create -f ingress-ssl.yaml