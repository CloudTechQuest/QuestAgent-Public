@description('Name of the network security group.')
param name string

@description('Azure region.')
param location string

@description('Tags applied to the resource.')
param tags object = {}

module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.4' = {
  name: 'deploy-${name}'
  params: {
    name: name
    location: location
    tags: tags
  }
}

output resourceId string = networkSecurityGroup.outputs.resourceId
