param location string
param storageAccountName string

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  name: '${storageAccountName}/default/sites'
  // Explicit dependency to ensure storage account is created before the share
  dependsOn: [
    sa
  ]
  properties: {
    shareQuota: 1024
  }
}

output storageAccountId string = sa.id
output storageAccountName string = sa.name
output fileShareName string = share.name
// Convenience output: simple share name (last segment) for volume mounting
// The created share path is <account>/default/sites so this is always 'sites'
output fileShareSimpleName string = 'sites'
