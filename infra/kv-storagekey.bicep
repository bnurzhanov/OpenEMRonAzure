param keyVaultName string
param storageAccountName string
@description('Name of the Key Vault secret to hold the storage account key')
param secretName string = 'storage-account-key'

// Retrieve first key of the storage account
var storageKeyValue = listKeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2023-01-01').keys[0].value

resource storageKeySecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: '${keyVaultName}/${secretName}'
  properties: {
    value: storageKeyValue
  }
}

// For modules that resolve the secret in-template, they only need the secret name (and vault name separately)
output storageAccountKeySecretName string = secretName
