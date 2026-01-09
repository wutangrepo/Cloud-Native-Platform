resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "80.13.2" # Helm Provider has quirks with exact versioning, so have to specify the patch version as well
  namespace  = "monitoring"

  create_namespace = true

  wait = true

  set = [
    {
      name  = "grafana.persistence.enabled"
      value = "false"
    },
    {
      name  = "prometheus.prometheusSpec.storageSpec"
      value = "" # # The default values is already for "" after check this chart's values.yaml for version 80.13 on Artifact Hub but keep it to avoid future updates changing the default value
    }
  ]

  depends_on = [
    aws_eks_node_group.main
  ]

  /* Migrating to Vault
  values here is a argument to helm_release resource, not function in Terraform but ${path.module} is a function/expression in Terraform

  values = [
    templatefile("${path.module}/alertmanager-values.tftpl", { SLACK_API_URL = var.slack_webhook_url })
  ]

  */
}