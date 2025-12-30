output "repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "configure_kubectl" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}