targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

// azure open ai -- regions currently support  gpt-4o 
@description('Location for the OpenAI resource group')
@allowed([ 'northcentralus','japaneast', 'canadaeast', 'francecentral', 'southcentralus',  'westus','eastus','eastus2'])
@metadata({
  azd: {
    type: 'location'
  }
})
param openAILocation string

//param openAISku string = 'S0'
param openAISku string = 'Standard'
param openAIApiVersion string = '2024-08-01-preview' //kimura 2025-02-10modify

param chatGptDeploymentCapacity int = 30             //kimura 2025-02-10modify
param chatGptDeploymentName string = 'gpt-35-turbo'
param chatGptModelName string = 'gpt-35-turbo'
param chatGptModelVersion string = '0125'
param embeddingDeploymentName string = 'embedding'
param embeddingDeploymentCapacity int = 1
param embeddingModelName string = 'text-embedding-ada-002'

// DALL-E v3 only supported in Sweden Central for now
@description('Location for the OpenAI DALL-E 3 instance resource group')
@allowed(['eastus'])
param dalleLocation string

param dalleDeploymentCapacity int = 1
param dalleDeploymentName string = 'dall-e-3'
param dalleModelName string = 'dall-e-3'
param dalleApiVersion string = '2023-12-01-preview'


// DALL-E v3 only supported in Sweden Central for now
//@description('Location for the GPT vision instance resource')
//@allowed(['swedencentral','westus',])
//param gptvisionLocation string

//param gptvisionDeploymentCapacity int = 1
//param gptvisionDeploymentName string = 'gpt-4-vision'
//param gptvisionModelName string = 'gpt-4'
//param gptvisionApiVersion string = '2023-12-01-preview'
//param gptvisionModelVersion string = 'vision-preview'

param formRecognizerSkuName string = 'S0'
param searchServiceIndexName string = 'azure-chat'
param searchServiceSkuName string = 'standard'

// TODO: define good default Sku and settings for storage account
param storageServiceSku object = { name: 'Standard_LRS' } 
param storageServiceImageContainerName string = 'images'

param resourceGroupName string = ''

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var tags = { 'azd-env-name': name }

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : 'rg-${name}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  name: 'all-resources'
  scope: rg
  params: {
    name: name
    resourceToken: resourceToken
    tags: tags
    openai_api_version: openAIApiVersion
    openAiLocation: openAILocation
    openAiSkuName: openAISku
    chatGptDeploymentCapacity: chatGptDeploymentCapacity
    chatGptDeploymentName: chatGptDeploymentName
    chatGptModelName: chatGptModelName
    chatGptModelVersion: chatGptModelVersion
    embeddingDeploymentName: embeddingDeploymentName
    embeddingDeploymentCapacity: embeddingDeploymentCapacity
    embeddingModelName: embeddingModelName
    dalleLocation: dalleLocation
    dalleDeploymentCapacity: dalleDeploymentCapacity
    dalleDeploymentName: dalleDeploymentName
    dalleModelName: dalleModelName
    dalleApiVersion: dalleApiVersion
    //gptvisionLocation: gptvisionLocation
    //gptvisionApiVersion: gptvisionApiVersion
    //gptvisionDeploymentCapacity: gptvisionDeploymentCapacity
    //gptvisionDeploymentName: gptvisionDeploymentName
    //gptvisionModelName: gptvisionModelName
    //gptvisionModelVersion: gptvisionModelVersion
    formRecognizerSkuName: formRecognizerSkuName
    searchServiceIndexName: searchServiceIndexName
    searchServiceSkuName: searchServiceSkuName
    storageServiceSku: storageServiceSku
    storageServiceImageContainerName: storageServiceImageContainerName
    location: location
  }
}

output APP_URL string = resources.outputs.url
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
