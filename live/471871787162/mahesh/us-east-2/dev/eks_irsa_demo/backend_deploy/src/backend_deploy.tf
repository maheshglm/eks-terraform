resource "helm_release" "backend" {
  name  = "backend"
  chart = "/Users/maheshgummaraju/Documents/Projects/DevOps/AWS/eks-terraform/k8s/irsa-test"

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = var.sa_name
  }

  # below 2 values are important to inject service account into pod
  set {
    name  = "serviceAccount.automountServiceAccountToken"
    value = true
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.irsa_role_arn
  }
}

