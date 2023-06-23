resource "helm_release" "certManager" {
  name             = "${var.labname}-cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.certManagerVersion
  namespace        = "${var.labname}-cert-manager"
  create_namespace = true

  values = [
    file("../helm-values/cert-manager-values.yaml")
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "controller.nodeSelector.kubernetes\\.io/os"
    value = "linux"
  }

  provisioner "local-exec" {
    command = "echo 'Waiting for cert-manager validating webhook to get its CA injected, so we can start to apply custom resources ...' && sleep 60"
  }
}

resource "kubectl_manifest" "certManagerClusterIssuerProd" {
  yaml_body = <<YAML
  apiVersion: "cert-manager.io/v1"
  kind: ClusterIssuer
  metadata:
    name: letsencrypt-prod
    namespace: cert-manager
  spec:
    acme:
      server: "https://acme-v02.api.letsencrypt.org/directory"
      email: "konstantinos.loizas@novatec-gmbh.de"
      privateKeySecretRef:
        name: letsencrypt-prod
      solvers:
      - dns01:
          azureDNS:
            subscriptionID: ${data.azurerm_subscription.current.subscription_id}
            resourceGroupName: ${data.azurerm_dns_zone.trainingsDnsZone.resource_group_name}
            hostedZoneName: ${data.azurerm_dns_zone.trainingsDnsZone.name}
            environment: AzurePublicCloud   
YAML

  depends_on = [helm_release.certManager]
}

resource "kubectl_manifest" "certManagerClusterIssuerStaging" {
  yaml_body = <<YAML
  apiVersion: "cert-manager.io/v1"
  kind: ClusterIssuer
  metadata:
    name: letsencrypt-staging
    namespace: cert-manager
  spec:
    acme:
      server: "https://acme-staging-v02.api.letsencrypt.org/directory"
      email: "konstantinos.loizas@novatec-gmbh.de"
      privateKeySecretRef:
        name: letsencrypt-staging
      solvers:
      - dns01:
          azureDNS:
            subscriptionID: ${data.azurerm_subscription.current.subscription_id}
            resourceGroupName: ${data.azurerm_dns_zone.trainingsDnsZone.resource_group_name}
            hostedZoneName: ${data.azurerm_dns_zone.trainingsDnsZone.name}
            environment: AzurePublicCloud   
YAML

  depends_on = [helm_release.certManager]
}