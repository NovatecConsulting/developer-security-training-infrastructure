resource "helm_release" "gitlab" {
  name             = "${var.labname}-gitlab"
  version          = var.gitlabVersion
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab"
  namespace        = "${var.labname}-ns-gitlab"
  create_namespace = true
  timeout          = 600000
  wait             = true

  values = [
    file("../helm-values/gitlab-values.yaml")
  ]

  set {
    name  = "nginx-ingress.enabled"
    value = "false"
  }

  set {
    name  = "global.ingress.annotations\\.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
    type  = "string"
  }

  set {
    name  = "certmanager.install"
    value = "false"
  }

  set {
    name  = "prometheus.install"
    value = "false"
  }

  set {
    name  = "global.hosts.gitlab.hostnameOverride"
    value = "${var.labname}.gitlab.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "global.ingress.class"
    value = "nginx"
  }

  set {
    name  = "global.admissionWebhooks.enabled"
    value = "false"
  }

  set {
    name  = "global.grafana.enable"
    value = "false"
  }

  set {
    name  = "global.prometheus.install"
    value = "false"
  }

  set {
    name  = "certmanager-issuer.email"
    value = "konstantinos.loizas@novatec-gmbh.de"
  }

  set {
    name  = "global.hosts.domain"
    value = "${var.labname}.gitlab.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "global.hosts.gitlab.name"
    value = "${var.labname}.gitlab.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "minio.ingress.enabled"
    value = "false"
  }

  set {
    name  = "registry.ingress.enabled"
    value = "false"
  }

  set {
    name  = "global.ingress.configureCertmanager"
    value = "false"
  }

  set {
    name  = "gitlab.webservice.ingress.tls.secretName"
    value = "${var.labname}-le-gitlab-secret"
    type  = "string"
  }

  set {
    name  = "certmanager.installCRDs"
    value = "false"
  }
}