resource "helm_release" "aad_pod_identity" {
  name             = "${var.labname}-aad-pod-identity"
  repository       = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  chart            = "aad-pod-identity"
  namespace        = "ingress-nginx"
  reset_values     = true
  force_update     = false
  recreate_pods    = true
  create_namespace = true

  # Run AAD Pod Identity on clusters with Kubenet
  set {
    name  = "nmi.allowNetworkPluginKubenet"
    value = "true"
  }

}

# Creates Identity
resource "azurerm_user_assigned_identity" "dns_identity" {
  name                = "${var.labname}-cert-manager-dns01"
  resource_group_name = data.azurerm_dns_zone.trainingsDnsZone.resource_group_name
  location            = var.location
}

# Creates Role Assignment
resource "azurerm_role_assignment" "dns_contributor" {
  scope                = data.azurerm_dns_zone.trainingsDnsZone.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.dns_identity.principal_id
}

# Creates the Identity Resource
resource "kubectl_manifest" "azure_identity" {
  yaml_body = <<YAML
  apiVersion: "aadpodidentity.k8s.io/v1"
  kind: AzureIdentity
  metadata:
    annotations:
      aadpodidentity.k8s.io/Behavior: namespaced
    name: certman-identity
    namespace: ${var.labname}-cert-manager
  spec:
    type: 0
    resourceID: ${azurerm_user_assigned_identity.dns_identity.id}
    clientID: ${azurerm_user_assigned_identity.dns_identity.client_id}
YAML

  depends_on = [helm_release.aad_pod_identity]
}

#Creates the Identity Resource Binding
resource "kubectl_manifest" "azure_identity_binding" {
  yaml_body = <<YAML
  apiVersion: "aadpodidentity.k8s.io/v1"
  kind: AzureIdentityBinding
  metadata:
    name: certman-id-binding
    namespace: ${var.labname}-cert-manager
  spec:
    azureIdentity: certman-identity
    selector: certman-label
YAML

  depends_on = [kubectl_manifest.azure_identity]
}