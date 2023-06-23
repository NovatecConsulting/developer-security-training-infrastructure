#With this provider you can deploy helm charts in the new created aks 
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8scluster.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8scluster.kube_config.0.cluster_ca_certificate)
    load_config_file       = "false"
  }
  debug = "true"
}

resource "helm_release" "ingress-nginx" {
  depends_on = [azurerm_kubernetes_cluster.k8scluster, azurerm_public_ip.loadBalancerIp]
  name       = "nginx"
  version    = var.nginxVersion
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"

  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "false"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }

  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.loadBalancerIp.ip_address
  }
}

resource "helm_release" "traefik" {
  depends_on   = [azurerm_kubernetes_cluster.k8scluster]
  name         = "traefik"
  version      = "10.19.4"
  repository   = "https://helm.traefik.io/traefik"
  chart        = "traefik"
  force_update = "true"
  namespace    = "traefik-v2"

  set {
    name  = "ingressClass.enabled"
    value = "true"
  }

  set {
    name  = "providers.kubernetesIngress.publishedService.enabled"
    value = "true"
  }

  set {
    type  = "string"
    name  = "additionalArguments"
    value = "{--providers.kubernetesingress.ingressclass=traefik,--global.sendanonymoususage=false,--log.level=DEBUG}"
  }

}

resource "helm_release" "postgres-operator" {
  depends_on = [azurerm_kubernetes_cluster.k8scluster]
  name       = "postgres-operator"
  version    = "1.9.0"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  chart      = "postgres-operator"
  namespace  = "operators"
}

#data "helm_repository" "bitnami" {
#  name = "bitnami"
#  url  = "https://charts.bitnami.com/"
#}

#resource "helm_release" "prom" { This is an example how to deploy prometheus into your aks

#   
#   name      = "prom"
#   chart     = "stable/prometheus-operator"
#   timeout   = "2200"
#}
