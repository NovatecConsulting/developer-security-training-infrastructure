resource "helm_release" "argocd" {
  name             = "${var.labname}-argocd"
  version          = var.argocdVersion
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "${var.labname}-ns-argocd"
  create_namespace = true
  timeout          = 600000
  wait             = true

  values = [
    file("../helm-values/argocd-values.yaml")
  ]

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "server.ingress.annotations\\.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
    type  = "string"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = "${var.labname}.argocd.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "server.ingress.rules[0].paths[0].pathType"
    value = "Prefix"
  }

  set {
    name  = "server.ingress.tls[0].hosts[0]"
    value = "${var.labname}.argocd.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "server.ingress.tls[0].secretName"
    value = "${var.labname}-le-argocd-secret"
    type  = "string"
  }
}