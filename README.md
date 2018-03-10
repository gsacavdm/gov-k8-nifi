# Deploying Apache NiFi in Kubernetes in Azure Government
This repository walks you through setting up an SSL-enabled single instance of Apache NiFi in Kubernetes in Azure Government.


## Pre-requisites
You must already have a Kubernetes cluster up and [running in Azure Government](https://github.com/gsacavdm/gov-arm-kube/tree/master/k8-cluster).

## Instructions
1. Apply the NiFi deployment and service to your Kubernetes cluster:

    ```bash
    kubectl apply -f deployment-nifi.yaml
    ```

1. Install Nginx-ingress and Lets Encrypt kubernetes charts. Make sure you update the `LEGO_EMAIL` in the second command

    ```bash
    helm install stable/nginx-ingress --name ssl-ingress --set rbac.create=true

    helm install --name lego --set config.LEGO_EMAIL=janedoe@contoso.com --set config.LEGO_URL=https://acme-v01.api.letsencrypt.org/directory stable/kube-lego --set rbac.create=true
    ```

1. Retrieve the ingress controller's `EXTERNAL-IP` address and add an `A` record for it in your DNS provider. It might take a few minutes for the external IP address to be available.

    ```bash
    kubectl get service ssl-ingress-nginx-ingress-controller 
    ```
  
    [Instructions to add an A record for GoDaddy](https://www.godaddy.com/help/add-an-a-record-19238)

1. Update the following values in `ingress-ssl.yaml` file:
    * `rules.host`: Set it to whatever hostname.domain you previously configured.
    * `rules.http.paths.path`: Set it to whatever path you want nifi to reside on. Note that by default, nifi already adds `/nifi` to the path. So setting this to `/` will result in `https://whatever.domain.com/nifi`. If you set this to `/foo` then your full path will be `https://whatever.domain.com/foo/nifi`
    * `tls.hosts`: Same as `rules.host`

1. Apply the SSL ingress.

  ```bash
  kubectl apply -f ingress-ssl.yaml
  ```

## Next Steps
[Get started with Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html)

## Outstanding Items
* Add persistent volumes
* Make it multi-instance