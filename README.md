# Multiplayer server deployment

This project is a collection of terraform files and kubernetes manifests for deploying [a simple server](https://github.com/rejdeboer/multiplayer-server) to Azure.
It supports the following features:

- Automatated reconciliation using Flux CD
- Easy provisioning and destruction of resources using Terraform
- Integration with Azure Key Vault using Kubernetes CSI driver
- Database deployment using Azure Postgres flexible server, protected using TLS
- Monitoring using Prometheus and Grafana
