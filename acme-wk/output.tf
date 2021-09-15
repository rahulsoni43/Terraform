
# Below is the output of the Kubeconfig that will be used to access cluster

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}
