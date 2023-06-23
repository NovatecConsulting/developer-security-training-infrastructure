resource "helm_release" "nexus" {
  name             = "${var.labname}-nexus"
  repository       = "https://sonatype.github.io/helm3-charts/"
  chart            = "nexus-repository-manager"
  version          = var.nexusVersion
  namespace        = "${var.labname}-ns-nexus"
  create_namespace = true

  values = [
    file("../helm-values/nexus-values.yaml")
  ]

  set {
    name  = "nexus.docker.enabled"
    value = "true"
  }

  set {
    name  = "nexus.docker.registries[0].host"
    value = "${var.labname}.nexus.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "nexus.docker.registries[0].port"
    value = "5000"
  }

  set {
    name  = "nexus.docker.registries[0].secretName"
    value = "${var.labname}-le-nexus-docker-secret"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "${var.labname}.nexus.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "${var.labname}-le-nexus-secret"
    type  = "string"
  }

  set {
    name  = "ingress.hostRepo"
    value = "${var.labname}.nexus.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "ingress.hostpath"
    value = "/nexus"
  }

  set {
    name  = "ingress.annotations\\.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
    type  = "string"
  }

  set {
    name  = "ingress.ingressClassName"
    value = "nginx"
    type  = "string"
  }
}