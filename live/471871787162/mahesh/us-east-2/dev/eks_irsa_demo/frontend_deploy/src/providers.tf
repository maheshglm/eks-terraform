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

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


#
#Plan: 1 to add, 0 to change, 0 to destroy.
#helm_release.frontend: Creating...
#helm_release.frontend: Still creating... [10s elapsed]
#helm_release.frontend: Still creating... [20s elapsed]
#helm_release.frontend: Still creating... [30s elapsed]
#helm_release.frontend: Still creating... [40s elapsed]
#╷
#│ Error: Kubernetes cluster unreachable: the server has asked for the client to provide credentials
#│
#│   with helm_release.frontend,
#│   on frontend_deploy.tf line 1, in resource "helm_release" "frontend":
#│    1: resource "helm_release" "frontend" {
#│