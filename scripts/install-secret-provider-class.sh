#!/usr/bin/env bash

echo "Installing AKV secrets provider class"

export identityClientId=$(az identity show -g MC_multiplayer-server_multiplayer-server-cluster_westeurope -n azurekeyvaultsecretsprovider-multiplayer-server-cluster --query clientId -o tsv)
echo "Secrets provider identity ID: " $identityClientId

cat << EOF | kubectl apply -f -
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: secret-provider
  namespace: default
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: $identityClientId 
    keyvaultName: "multiplayer-server-vault"
    objects:  |
      array:
        - |
          objectName: postgres-username
          objectType: secret
        - |
          objectName: postgres-password
          objectType: secret
        - |
          objectName: jwt-secret-key
          objectType: secret
        - |
          objectName: external-dns-secret
          objectType: secret
    tenantId: "33775a2a-f4ac-4722-9358-3764d5110404"
  secretObjects:
  - data:
    - key: postgres-username
      objectName: postgres-username
    - key: postgres-password
      objectName: postgres-password
    - key: jwt-secret-key
      objectName: jwt-secret-key
    secretName: multiplayer-server-secrets
    type: Opaque
  - data:
    - key: azure.json
      objectName: external-dns-secret
    secretName: external-dns-secret
    type: Opaque
EOF
