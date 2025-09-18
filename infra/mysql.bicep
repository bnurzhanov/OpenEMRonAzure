param location string
param mySqlName string
@secure()
param mysqlUser string

@secure()
param mysqlPassword string

// Name of the primary OpenEMR application database to create on the flexible server
@description('MySQL database name to provision for OpenEMR')
param openEmrDatabaseName string = 'openemr'
@description('MySQL database charset (utf8mb4 recommended)')
param openEmrDbCharset string = 'utf8mb4'
@description('MySQL database collation (must match charset; OpenEMR defaults to utf8mb4_general_ci)')
param openEmrDbCollation string = 'utf8mb4_general_ci'


resource mysql 'Microsoft.DBforMySQL/flexibleServers@2023-06-01-preview' = {
  name: mySqlName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: mysqlUser
    administratorLoginPassword: mysqlPassword
    version: '8.0.21'
    storage: {
      storageSizeGB: 32
    }
  }
}

// Explicitly create the OpenEMR application database (so the app does not rely on implicit creation logic)
resource openEmrDb 'Microsoft.DBforMySQL/flexibleServers/databases@2023-06-01-preview' = {
  name: openEmrDatabaseName
  parent: mysql
  properties: {
    charset: openEmrDbCharset
    collation: openEmrDbCollation
  }
}

output openEmrDatabaseName string = openEmrDatabaseName
