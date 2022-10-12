provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# if it is EKS or managed k8s, we need to enable k8s and helm providers as below

#provider "kubernetes" {
#  host                   = var.cluster_endpoint
#  cluster_ca_certificate = base64decode(var.cluster_ca)
#  token                  = var.cluster_token
#}
#
#provider "helm" {
#  kubernetes {
#    host                   = var.cluster_endpoint
#    cluster_ca_certificate = base64decode(var.cluster_ca)
#    token                  = var.cluster_token
#  }
#}

resource "helm_release" "helm2048" {
  name  = "helm2048"
  chart = "/Users/maheshgummaraju/Documents/Projects/DevOps/AWS/eks-terraform/k8s/helm2048"

  set {
    name  = "replicaCount"
    value = 3
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}