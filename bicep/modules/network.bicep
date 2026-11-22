@description('Name of the virtual network.')
param name string

@description('Azure region.')
param location string

@description('Address space for the virtual network.')
param addressPrefix string = '10.202.0.0/16'

@description('Name of the subnet that hosts the Redis private endpoint.')
param redisSubnetName string = 'snet-redis-001'

@description('Address range for the Redis private endpoint subnet.')
param redisSubnetPrefix string = '10.202.10.0/24'

@description('Resource ID of the NSG attached to the Redis subnet.')
param networkSecurityGroupResourceId string

@description('Tags applied to the resource.')
param tags object = {}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.10.2' = {
  name: 'deploy-${name}'
  params: {
    name: name
    location: location
    addressPrefixes: [
      addressPrefix
    ]
    subnets: [
      {
        name: redisSubnetName
        addressPrefix: redisSubnetPrefix
        networkSecurityGroupResourceId: networkSecurityGroupResourceId
      }
    ]
    tags: tags
  }
}

output resourceId string = virtualNetwork.outputs.resourceId
output redisSubnetResourceId string = virtualNetwork.outputs.subnetResourceIds[0]
