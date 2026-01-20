output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = module.eks.cluster_primary_security_group_id
}

output "oidc_provider_arn" {
  description = "The Amazon Resource Name (ARN) of the OIDC identity provider for the cluster"
  value       = module.eks.oidc_provider_arn
}

output "eks_cluster_oidc_provider_issuer_url" {
  value       = module.eks.cluster_oidc_issuer_url
  description = "The OIDC issuer URL of the EKS cluster"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "value of the EKS cluster endpoint"
}