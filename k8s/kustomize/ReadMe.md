# Kustomize Demo

This is the sample repo to demonstrate Kustomize functionality.

- To build the manifests using kustomize
  `kubectl kustomize <path of the environment>` => `kubectl kustomize overlays/prod`

- To apply the resources using kustomize
  `kubectl apply -k <path of the environment` 

- To Delete the resources using kustomize
  `kubectl delete -k <path of the environment`

