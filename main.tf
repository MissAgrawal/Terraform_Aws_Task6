provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        env = "dev"
        region = "IN"
        App = "wordpress"
      }
    }
    template {
      metadata {
        labels = {
          env = "dev"
          region = "IN"
          App = "wordpress"
        }
      }
      spec {
        container {
          image = "wordpress:4.8-apache"
          name = "wordpressdb"
        }
      }
    }
  }
}
resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
  }
  spec {
    selector = {
      App = kubernetes_deployment.wordpress.spec.0.template.0.metadata[0].labels.App
    }
  port {
    node_port = 32123
    port = 80
    target_port = 80
  }
  type = "NodePort"
  }
}