param location string
param logAnalyticsName string

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    retentionInDays: 30
  }
}

// Needed to retrieve the shared key for ACA log ingestion
resource sharedKeys 'Microsoft.OperationalInsights/workspaces/sharedKeys@2022-10-01' = {
  parent: workspace
  name: 'sharedKeys'
}

// Existing output (resource ID) retained for App Insights module
output workspaceId string = workspace.id
// Customer (workspace) ID GUID required by ACA managedEnvironment appLogsConfiguration
output workspaceCustomerId string = workspace.properties.customerId
// bicep:disable-next-line outputs-should-not-contain-secrets -- Required to configure ACA log collection
@secure()
output workspaceSharedKey string = sharedKeys.properties.primarySharedKey
