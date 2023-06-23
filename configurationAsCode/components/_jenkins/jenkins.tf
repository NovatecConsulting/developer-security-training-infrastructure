resource "helm_release" "jenkins" {
  name             = "${var.labname}-jenkins"
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = var.jenkinsVersion
  namespace        = "${var.labname}-ns-jenkins"
  create_namespace = true

  values = [
    file("../helm-values/jenkins-values.yaml")
  ]

  set {
    name  = "controller.installLatestPlugins"
    value = "false"
  }

  set {
    name  = "controller.ingress.enabled"
    value = "true"
  }

  set {
    name  = "controller.ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name  = "controller.ingress.annotations\\.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
    type  = "string"
  }

  set {
    name  = "controller.ingress.annotations\\.kubernetes\\.io/ingress.class"
    value = "nginx"
    type  = "string"
  }

  set {
    name  = "controller.ingress.hostName"
    value = "${var.labname}.jenkins.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "controller.ingress.tls[0].hosts[0]"
    value = "${var.labname}.jenkins.${data.azurerm_dns_zone.trainingsDnsZone.name}"
  }

  set {
    name  = "controller.ingress.tls[0].secretName"
    value = "${var.labname}-le-jenkins-secret"
    type  = "string"
  }

  set {
    name  = "controller.ingress.path"
    value = "/jenkins"
  }

  set {
    name  = "controller.jenkinsUriPrefix"
    value = "/jenkins"
  }

}

resource "kubernetes_service_account_v1" "jenkinsServiceAccount" {
  metadata {
    name      = "jenkinsworker"
    namespace = helm_release.jenkins.namespace
  }

  automount_service_account_token = true

  depends_on = [helm_release.jenkins]
}

resource "kubernetes_cluster_role_binding" "jenkinsRBAC" {
  metadata {
    name = "jenkinsworker-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkinsworker"
    namespace = helm_release.jenkins.namespace
  }

  depends_on = [kubernetes_service_account_v1.jenkinsServiceAccount]
}
