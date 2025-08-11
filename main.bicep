// Parameters
param location string = resourceGroup().location

// Variables
var uniqueName = uniqueString(resourceGroup().id)
var storageAccountName = 'store${uniqueName}'
var keyVaultName = 'kv${uniqueName}'
var eventHubNamespaceName = 'ehns${uniqueName}'
var databricksWorkspaceName = 'dbw${uniqueName}'

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    family: 'A'
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    isHnsEnabled: true
  }
}

// Key Vault with vault access policy permission model
resource keyVault 'Microsoft.KeyVault/vaults@2024-12-01-preview' = {
  name: keyVaultName
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    enableRbacAuthorization: false
  }
}


// Event Hubs Namespace
resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
}

// Event Hubs
resource organizationEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-organization'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource locationEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-location'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource practitionerEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-practitioner'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource practitionerRoleEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-practitioner-role'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource patientEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-patient'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource encounterEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-encounter'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource conditionEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-condition'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}

resource observationEventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: eventHubNamespace
  name: 'fhir-observation'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 4
  }
}


// Databricks Workspace
resource databricks 'Microsoft.Databricks/workspaces@2024-09-01-preview' = {
  name: databricksWorkspaceName
  location: location
  sku: {
    name: 'premium'
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', 'databricks-rg-${uniqueName}')
  }
}
