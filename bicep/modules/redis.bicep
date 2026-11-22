@description('Name of the Redis resource. Must be globally unique.')
param name string

@description('Azure region.')
param location string

@description('SKU for Azure Managed Redis.')
param skuName string = 'Balanced_B10'

@description('Subnet that hosts the private endpoint.')
param subnetResourceId string

@description('Private DNS zone for the private endpoint.')
param privateDnsZoneResourceId string

@description('Tags applied to the resources.')
param tags object = {}

module redisEnterprise 'br/public:avm/res/cache/redis-enterprise:0.5.2' = {
  name: 'deploy-${name}'
  params: {
    name: name
    location: location
    skuName: skuName
    publicNetworkAccess: 'Enabled'
    database: {
      persistence: {
        frequency: '1h'
        type: 'rdb'
      }
    }
    privateEndpoints: [
      {
        subnetResourceId: subnetResourceId
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: privateDnsZoneResourceId
            }
          ]
        }
        tags: tags
      }
    ]
    tags: tags
  }
}

output resourceId string = redisEnterprise.outputs.resourceId
output name string = redisEnterprise.outputs.name
