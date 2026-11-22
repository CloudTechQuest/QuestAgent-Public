targetScope = 'resourceGroup'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Globally unique name for the Redis resource.')
param redisName string = 'ctqredisacus001'

@description('Tags applied to every resource.')
param tags object = {
  Environment: 'Prod'
  Role: 'DeploymentValidation'
}

module nsg 'modules/nsg.bicep' = {
  name: 'nsg'
  params: {
    name: 'nsg-redis-cus-001'
    location: location
    tags: tags
  }
}

module network 'modules/network.bicep' = {
  name: 'network'
  params: {
    name: 'vnet-ctq-cus-001'
    location: location
    networkSecurityGroupResourceId: nsg.outputs.resourceId
    tags: tags
  }
}

module privateDns 'modules/privatedns.bicep' = {
  name: 'privatedns'
  params: {
    virtualNetworkResourceId: network.outputs.resourceId
    tags: tags
  }
}

module redis 'modules/redis.bicep' = {
  name: 'redis'
  params: {
    name: redisName
    location: location
    subnetResourceId: network.outputs.redisSubnetResourceId
    privateDnsZoneResourceId: privateDns.outputs.resourceId
    tags: tags
  }
}

output redisResourceId string = redis.outputs.resourceId
