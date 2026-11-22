@description('Private DNS zone name. Azure Managed Redis uses privatelink.redis.azure.net.')
param zoneName string = 'privatelink.redis.azure.net'

@description('Resource ID of the virtual network to link to the zone.')
param virtualNetworkResourceId string

@description('Tags applied to the resource.')
param tags object = {}

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.1' = {
  name: 'deploy-${zoneName}'
  params: {
    name: zoneName
    location: 'global'
    virtualNetworkLinks: [
      {
        name: 'link-vnet-ctq-cus-001'
        virtualNetworkResourceId: virtualNetworkResourceId
        registrationEnabled: false
      }
    ]
    tags: tags
  }
}

output resourceId string = privateDnsZone.outputs.resourceId
