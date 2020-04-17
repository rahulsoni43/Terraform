resource "azuread_application" "aks-application" {
  name = "aks-ad"
}

resource "azuread_service_principal" "aks-pc"{
  application_id = azuread_application.aks-application.application_id
  app_role_assignment_required = false
}

resource "azuread_service_principal_password" "aks-password" {
  service_principal_id = azuread_service_principal.aks-pc.id
  value = "VT=uSgbTanZhyz@%nL9Hpd+Tfay_MRV#"
  end_date             = "2099-01-01T01:02:03Z"
}
