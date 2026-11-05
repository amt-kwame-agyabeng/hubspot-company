job "hubspot-company" {
  datacenters = ["dc1"]
  type        = "service"

  group "hubspot" {
    count = 1

    network {
      mode = "host"

      port "http" {
        static = 5104
      }

      port "postgres" {
        static = 5433
        to     = 5432
      }

      port "redis" {
        static = 6379
      }
    }

    volume "postgres-data" {
      type      = "host"
      source    = "hubspot-postgres"
      read_only = false
    }

    volume "redis-data" {
      type      = "host"
      source    = "hubspot-redis"
      read_only = false
    }

    task "postgres" {
      driver = "docker"

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      config {
        image = "postgres:15-alpine"
        ports = ["postgres"]
      }

      env {
        POSTGRES_USER     = "stage_user"
        POSTGRES_PASSWORD = "stage_password"
        POSTGRES_DB       = "hubspot_stage"
      }

      volume_mount {
        volume      = "postgres-data"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      resources {
        cpu    = 500
        memory = 768
      }
    }

    task "redis" {
      driver = "docker"

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      config {
        image = "redis:7-alpine"
        ports = ["redis"]
        args  = ["--appendonly", "yes", "--maxmemory", "512mb", "--maxmemory-policy", "allkeys-lru"]
      }

      volume_mount {
        volume      = "redis-data"
        destination = "/data"
        read_only   = false
      }

      resources {
        cpu    = 250
        memory = 256
      }
    }

    task "app" {
      driver = "docker"

      shutdown_delay = "10s"

      config {
        image = "hubspot-company:staging"
        ports = ["http"]
        command = "sh"
        args = [
          "-c",
          "until pg_isready -h 172.17.0.3 -p 5432 -U stage_user -d hubspot_stage; do echo 'Waiting for PostgreSQL'; sleep 2; done; exec gunicorn --bind 0.0.0.0:5104 --workers 2 --keep-alive 2 app:app"
        ]
      }

      env {
        FLASK_ENV    = "staging"
        DATABASE_URL = "postgresql://stage_user:stage_password@172.17.0.3:5432/hubspot_stage"
        REDIS_URL    = "redis://127.0.0.1:6379/0"
        LOG_LEVEL    = "INFO"
        PORT         = "5104"
        SECRET_KEY   = "nomad-local-demo-only-change-before-production"
      }

      service {
        name     = "hubspot-company"
        provider = "consul"
        port     = "http"

        check {
          name     = "hubspot-health"
          type     = "http"
          path     = "/health-simple"
          interval = "10s"
          timeout  = "3s"
        }
      }

      resources {
        cpu    = 1000
        memory = 768
      }
    }
  }
}
