# Azure Container Apps Terraform Module

Módulo de Terraform para desplegar Azure Container Apps en el **Infra Lab** de School of Learning.

## ¿Qué hace este módulo?

- Despliega una **Azure Container App** con configuración básica
- Configura **health probes** automáticamente
- Habilita **ingress externo** para acceso público
- Usa el **Container Apps Environment compartido** del lab

## Requisitos

| Name | Version |
|------|---------|
| terraform | >= 1.6.0 |
| azurerm | ~> 4.0 |

## Uso en el repositorio de infraestructura

### Ejemplo básico para el lab

```hcl
# En tu rama feature/<equipo>
module "my_team_app" {
  source = "git::git@ssh.dev.azure.com:v3/EndavaMVD/SchoolOf2025/mg_fg_terraform_module.git?ref=main"
  
  # Variables requeridas
  app_name                     = "mi-equipo-app"  # Nombre único para tu equipo
  container_image              = "tu-acr.azurecr.io/tu-app:latest"
  resource_group_name          = var.resource_group_name  # Usar variable del lab
  container_app_environment_id = var.container_app_environment_id  # Environment compartido
}

# Obtener la URL de tu app desplegada
output "app_url" {
  description = "URL para acceder a la aplicación"
  value       = module.my_team_app.app_url
}
```

### Ejemplo con configuración personalizada

```hcl
module "my_team_app" {
  source = "git::git@ssh.dev.azure.com:v3/EndavaMVD/SchoolOf2025/mg_fg_terraform_module.git?ref=main"
  
  # Variables requeridas
  app_name                     = "mi-equipo-api"
  container_image              = "tu-acr.azurecr.io/tu-api:v1.0.0"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  
  # Configuración opcional
  container_port    = 8080           # Puerto de tu aplicación
  health_check_path = "/api/health"  # Endpoint de health check
  cpu              = 0.5             # CPU asignada
  memory           = "1Gi"           # Memoria asignada
}
```

## Variables

| Nombre | Descripción | Tipo | Por defecto | Requerido |
|--------|-------------|------|-------------|:---------:|
| `app_name` | Nombre único para la Container App (usar nombre del equipo) | `string` | - | ✅ |
| `container_image` | URL completa de la imagen Docker en ACR | `string` | - | ✅ |
| `resource_group_name` | Nombre del Resource Group (usar variable del lab) | `string` | - | ✅ |
| `container_app_environment_id` | ID del Container Apps Environment compartido | `string` | - | ✅ |
| `container_port` | Puerto que expone tu aplicación | `number` | `8000` | ❌ |
| `health_check_path` | Endpoint para el health check | `string` | `"/health"` | ❌ |
| `cpu` | CPU asignada al contenedor | `number` | `0.25` | ❌ |
| `memory` | Memoria asignada al contenedor | `string` | `"0.5Gi"` | ❌ |

## Outputs

| Nombre | Descripción |
|--------|-------------|
| `app_url` | URL pública para acceder a tu aplicación |
| `app_id` | ID de la Container App creada |
| `app_name` | Nombre de la Container App |
| `app_fqdn` | Dominio completo de la Container App |

## Health Check

El módulo configura automáticamente health probes que verifican:
- **Liveness**: Si el contenedor está funcionando
- **Readiness**: Si está listo para recibir tráfico

**Importante**: Tu aplicación debe responder con HTTP 200 en el endpoint `health_check_path`.

### Ejemplo de endpoint de health

```python
# FastAPI
@app.get("/health")
def health():
    return {"status": "ok"}
```

## Workflow para el Lab

1. **Crear rama**: `feature/<tu-equipo>`
2. **Usar este módulo** en tu archivo `.tf` con la URL del repo en `source`
3. **Configurar variables** requeridas
4. **Crear Pull Request** y agregar a **Gonzalo Rodriguez** como reviewer
5. **Pipeline automática**: 
   - Al abrir PR → `terraform plan`
   - Al hacer merge → `terraform apply`

