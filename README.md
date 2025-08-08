## Overview

This repository defines Azure infrastructure for a real-time health data platform.  
Deploys automatically to Azure via GitHub Actions on pushes to `main`.

## Prerequisites

1. **Azure subscription** with permission to create resources.
2. **Resource Group** (default name in workflow: `health-data-platform`):
   ```bash
   az group create -n health-data-platform -l eastus2

## What it deploys

- **Storage Account** (HNS enabled for ADLS Gen2; no public blob access)
- **Event Hubs Namespace** with hubs:
  - `fhir-organization`
  - `fhir-location`
  - `fhir-practitioner`
  - `fhir-practitioner-role`
  - `fhir-patient`
  - `fhir-encounter`
  - `fhir-condition`
  - `fhir-observation`
- **Azure Databricks Workspace** (Premium SKU)

## Manual Deployment

If you want to deploy locally instead of using Actions

#### Login and pick subscription
`az login`
`az account set --subscription "<your-subscription-id>"`

#### Ensure resource group exists
`az group create -n health-data-platform -l eastus2`

#### Build (optional; az can deploy .bicep directly)
`az bicep build --file main.bicep`

#### Deploy to the resource group
```
az deployment group create \
  --resource-group health-data-platform \
  --template-file main.bicep \
  --parameters location=eastus2
```

#### Clean up

`az group delete -n health-data-platform --yes --no-wait`
