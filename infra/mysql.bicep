param location string
param mySqlName string
@secure()
param mysqlUser string

@secure()
param mysqlPassword string

// Name of the primary OpenEMR application database to create on the flexible server
@description('MySQL database name to provision for OpenEMR')
param openEmrDatabaseName string = 'openemr'
@description('MySQL database charset (utf8mb4 recommended for OpenEMR)')
param openEmrDbCharset string = 'utf8mb4'
@description('MySQL database collation (OpenEMR compatible)')
param openEmrDbCollation string = 'utf8mb4_unicode_ci'


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
    version: '8.4'
    storage: {
      storageSizeGB: 32
    }
    network: {
      publicNetworkAccess: 'Enabled'
      // No delegatedSubnetResourceId means public access is allowed
      // No privateDnsZoneResourceId means no private DNS zone
    }
  }
}

// Configure MySQL to require SSL connections for security
resource requireSecureTransport 'Microsoft.DBforMySQL/flexibleServers/configurations@2023-06-01-preview' = {
  name: 'require_secure_transport'
  parent: mysql
  properties: {
    value: 'ON'
    source: 'user-override'
  }
}

// Pre-create the OpenEMR database since Azure MySQL admin user can't act like traditional root
// This ensures the database exists with proper charset/collation before OpenEMR starts
resource openEmrDb 'Microsoft.DBforMySQL/flexibleServers/databases@2023-06-01-preview' = {
  name: openEmrDatabaseName
  parent: mysql
  properties: {
    charset: openEmrDbCharset
    collation: openEmrDbCollation
  }
}

output openEmrDatabaseName string = openEmrDatabaseName
