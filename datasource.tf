provider "azurerm" {
  features{}
}

data "azurerm_resource_group" "name1"{
    name = "tavnrg"
}

resource "azurerm_virtual_network" "tavn1" {
  name                = "tavn1"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.name1.location
  resource_group_name = data.azurerm_resource_group.name1.name
}

resource "azurerm_subnet" "tavnsn" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.name1.name
  virtual_network_name = azurerm_virtual_network.tavn1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tavnnic" {
  name                = "tavnnic"
  location            = data.azurerm_resource_group.name1.location
  resource_group_name = data.azurerm_resource_group.name1.name

  ip_configuration {
    name                          = "tavnip"
    subnet_id                     = azurerm_subnet.tavnsn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.tavnpip.id
  }
}
data "azurerm_public_ip" "tavnpip" {
  name                = "tavnpip"
  resource_group_name = data.azurerm_resource_group.name1.name
}