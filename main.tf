module "wandb_infra" {
  source                         = "wandb/wandb/aws"
  version                        = "~>7.0"
  use_internal_queue             = true
  external_dns                = true
  namespace                      = var.namespace
  domain_name                    = var.domain_name
  subdomain                      = var.subdomain
  zone_id                        = var.zone_id
  license                        = var.license
  deletion_protection            = false
  enable_flow_log                = false
  keep_flow_log_bucket           = false
  allowed_inbound_cidr           = var.allowed_inbound_cidr
  allowed_inbound_ipv6_cidr      = var.allowed_inbound_ipv6_cidr
  public_access                  = true
  kubernetes_public_access       = true
  kubernetes_public_access_cidrs = ["0.0.0.0/0"]
  eks_addon_kube_proxy_version   = "v1.29.15-eksbuild.26"
  eks_cluster_version            = var.eks_cluster_version
  size                           = "small"

}

data "aws_eks_cluster" "cluster" {
  name = module.wandb_infra.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.wandb_infra.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# --- Helm provider ---
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

output "url" {
  value = module.wandb_infra.url
}

output "bucket" {
  value = module.wandb_infra.bucket_name
}
