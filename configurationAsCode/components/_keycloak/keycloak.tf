resource "helm_release" "keycloak" {
  name             = "${var.labname}-keycloak"
  repository       = "https://codecentric.github.io/helm-charts"
  chart            = "keycloak"
  namespace        = "${var.labname}-ns-keycloak"
  create_namespace = true

  values = [
    file("../helm-values/keycloak-values.yaml")
  ]

  set {
    name  = "ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "ingress.annotations\\.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
    type  = "string"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "${var.labname}.keycloak.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "ingress.rules[0].host"
    value = "${var.labname}.keycloak.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "ingress.rules[0].paths[0].path"
    value = "/"
  }

  set {
    name  = "ingress.rules[0].paths[0].pathType"
    value = "Prefix"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "${var.labname}-le-keycloak-secret"
    type  = "string"
  }

  set {
    name  = "ingress.console.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "ingress.console.tls[0].hosts[0]"
    value = "${var.labname}.keycloak.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "ingress.console.rules[0].host"
    value = "${var.labname}.keycloak.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "ingress.console.rules[0].paths[0].path"
    value = "/auth/admin"
  }

  set {
    name  = "ingress.console.rules[0].paths[0].pathType"
    value = "Prefix"
  }

  set {
    name  = "ingress.console.tls[0].secretName"
    value = "${var.labname}-le-keycloak-secret"
    type  = "string"
  }

}