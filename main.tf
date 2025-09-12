# Main resource: Defines an Azure Container App.
resource "azurerm_container_app" "app" {
  name = var.app_name
  container_app_environment_id = var.container_app_environment_id

  # Resource group:
  resource_group_name = var.resource_group_name
  
  # "Single" = only one version active at a time.
  revision_mode = "Single"

  # Defines how the container that will be executed will look like.
  template {
    # Docker container setup.
    container {
      name = "api"
      image = var.container_image
      cpu = var.cpu    
      memory = var.memory

      # Is the container still "alive"?
      # If it doesn't respond, Azure automatically restarts it.
      liveness_probe {
        transport = "HTTP"             
        path = var.health_check_path   
        port = var.container_port      
        initial_delay = 20              
        interval_seconds = 60         
      }

      # Is the container ready to receive traffic?
      # During a deployment, Azure expects this to respond "OK" before sending traffic (http requests).
      readiness_probe {
        transport = "HTTP"            
        path = var.health_check_path   
        port = var.container_port      
        initial_delay = 10           
        interval_seconds = 30           
      }
    }
  }

  # INGRESS: Network configuration - entry point for external HTTP requests.
  ingress {
    # Sets the app to be accessible from the internet.
    external_enabled = true
    
    # Port where the API listens inside the container.
    target_port = var.container_port
    
    # TRAFFIC_WEIGHT: How to distribute traffic between versions
    traffic_weight {
      # Send traffic to the newest version.
      latest_revision = true
      
      # Send 100% of traffic to that version.
      percentage = 100
    }
  }

  # TAGS: Tags to organize and identify resources in Azure.
  tags = {
    ManagedBy = "Terraform"           
    Module = "mg_fg_terraform_module"   
    Team = "Mariana Guerra and Federico Gonzalez" 
  }
}