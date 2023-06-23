# when applying upstream's YAML split into individual resources as done below,
# it is not guaranteed the required namespaces included therein are created
# first, hence now explicitly creating them here, then to be overwritten by
# upstream's definition

resource "kubectl_manifest" "namespace_tekton_pipelines" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: tekton-pipelines
YAML
}

resource "kubectl_manifest" "namespace_tekton_pipelines_resolvers" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: tekton-pipelines-resolvers
YAML
}

# fetch raw multi-resource yaml
data "http" "tekton_pipeline_yaml" {
  url = "https://storage.googleapis.com/tekton-releases/pipeline/previous/${var.tektonVersion}/release.yaml"
}

# split raw yaml into individual resources
data "kubectl_file_documents" "tekton_pipeline_yaml" {
  content = data.http.tekton_pipeline_yaml.response_body
}

# apply each resource from the yaml one by one
resource "kubectl_manifest" "tekton_pipeline_yaml" {
  for_each  = data.kubectl_file_documents.tekton_pipeline_yaml.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.namespace_tekton_pipelines,
    kubectl_manifest.namespace_tekton_pipelines_resolvers
  ]
}

# fetch a raw multi-resource yaml
data "http" "tekton_dashboard_yaml" {
  url = "https://storage.googleapis.com/tekton-releases/dashboard/previous/${var.tektonDashboardVersion}/release-full.yaml"
}

# split raw yaml into individual resources
data "kubectl_file_documents" "tekton_dashboard_yaml" {
  content = data.http.tekton_dashboard_yaml.response_body
}

# apply each resource from the yaml one by one
resource "kubectl_manifest" "tekton_dashboard_yaml" {
  for_each  = data.kubectl_file_documents.tekton_dashboard_yaml.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.namespace_tekton_pipelines
  ]
}
