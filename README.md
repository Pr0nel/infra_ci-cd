# Infra CI/CD Pipeline

[![CI/CD status](https://img.shields.io/github/actions/workflow/status/Pr0nel/infra_ci-cd/ci-cd.yml?label=CI/CD&logo=github)](https://github.com/Pr0nel/infra_ci-cd/actions/) [![Terraform](https://img.shields.io/badge/Terraform-1.5+-purple.svg)](https://www.terraform.io/) [![Multi-Cloud](https://img.shields.io/badge/Cloud-AWS%20%7C%20Azure%20%7C%20GCP-blue.svg)](https://github.com/Pr0nel/infra_ci-cd)

Este repositorio contiene la infraestructura como código (IaC) y el pipeline de CI/CD para desplegar recursos en múltiples proveedores de nube (GCP, AWS, Azure). Utiliza Terraform para gestionar la infraestructura y GitHub Actions para automatizar el proceso de implementación.

---

- [Infra CI/CD Pipeline](#infra-cicd-pipeline)
- [📖 Descripción del Proyecto](#-descripción-del-proyecto)
- [✨ Características Principales](#-características-principales)
- [📦 Requisitos Previos](#-requisitos-previos)
  - [Software](#software)
  - [Conocimientos](#conocimientos)
- [🚀 Configuración del Proyecto](#-configuración-del-proyecto)
  - [1. Configuración de Secrets en GitHub Actions](#1-configuración-de-secrets-en-github-actions)
    - [Secrets comunes](#secrets-comunes)
    - [Secrets para AWS](#secrets-para-aws)
    - [Secrets para Azure](#secrets-para-azure)
    - [Secrets para GCP](#secrets-para-gcp)
  - [2. Ejecución del Pipeline](#2-ejecución-del-pipeline)
- [🏗️ Estructura y arquitectura del proyecto](#️-estructura-y-arquitectura-del-proyecto)
- [🎯 Pipeline de CI/CD](#-pipeline-de-cicd)
- [🤝 Contribuciones](#-contribuciones)
- [📄 Licencia](#-licencia)

---

# 📖 Descripción del Proyecto

Este proyecto implementa un pipeline de CI/CD multi-nube que automatiza el despliegue de infraestructura utilizando:

- Terraform para infraestructura como código (IaC)
- GitHub Actions para automatización de CI/CD
- Múltiples proveedores de nube (AWS, Azure, GCP)

El pipeline se encarga de validar, planificar y aplicar cambios en la infraestructura de manera segura y consistente, siguiendo las mejores prácticas de DevOps.

---

# ✨ Características Principales

- 🌐 Multi-Nube: Soporte completo para AWS, Azure y GCP.
- 🤖 Automatización: Pipeline completamente automatizado con GitHub Actions.
- 🔒 Seguridad: Gestión segura de credenciales mediante GitHub Secrets.
- ✅ Validación: Validación de credenciales, configuración y sintaxis antes de aplicar.
- 📦 Backend Remoto: State de Terraform persistente en la nube.
- 🔄 Idempotencia: Ejecuciones seguras y repetibles.
- 🚀 Escalabilidad: Diseñado para ser extensible y adaptable a diferentes entornos y proyectos.

---

# 📦 Requisitos Previos

## Software

- Cuenta activa en GitHub
- Acceso a uno o más proveedores de nube:
  - AWS: IAM user con permisos administrativos
  - Azure: Service Principal con rol Contributor
  - GCP: Service Account con permisos adecuados

## Conocimientos

- Fundamentos de Terraform
- Conceptos básicos de CI/CD
- Familiaridad con el proveedor de nube elegido

---

# 🚀 Configuración del Proyecto

## 1. Configuración de Secrets en GitHub Actions

Asegúrate de agregar los siguientes secrets en Settings > Secrets and variables > Actions de tu repositorio de GitHub:

### Secrets comunes
- CLOUD_PROVIDER: Proveedor de nube (gcp, aws, azure).
- TF_VAR_REGION: Región de GCP donde se desplegarán los recursos.
- TF_VAR_BUCKET_NAME: Nombre único del bucket de almacenamiento.
    
### Secrets para AWS
- AWS_ACCESS_KEY_ID: Access Key ID de IAM
- AWS_SECRET_ACCESS_KEY: Secret Access Key
    
### Secrets para Azure
- AZURE_CREDENTIALS: JSON del Service Principal
    
### Secrets para GCP
- GCP_CREDENTIALS_JSON: Credenciales de cuenta de servicio de GCP en formato JSON.
- GCP_PROJECT_ID: ID del proyecto de GCP donde se crearán los recursos.

## 2. Ejecución del Pipeline

El pipeline se ejecuta automáticamente cuando:

    - Se realiza un push al branch main.
    - Realizas un Pull Request hacia main.
    - Se activa manualmente desde la interfaz de GitHub Actions.

Para ejecutarlo manualmente:

    - Ve a la pestaña Actions en tu repositorio de GitHub.
    - Selecciona el workflow "CI/CD Pipeline for Multi-Cloud Deployment".
    - Haz clic en Run workflow.
    - Selecciona el branch y confirma.

Monitoreo:

    - Los logs detallados están disponibles en la pestaña Actions.
    - Cada paso muestra su estado (éxito, fallo, en progreso).
    
---

# 🏗️ Estructura y arquitectura del proyecto

```
infra_ci-cd/
├── terraform/
│    ├── aws/
|    |   ├── backend.tf     # Configuración del backend.
│    │   ├── main.tf        # Configuración principal de Terraform para AWS.
│    │   ├── variables.tf   # Variables utilizadas en Terraform.
│    │   └── outputs.tf     # Salidas del estado de Terraform.
│    ├── azure/
|    |   ├── backend.tf     # Configuración del backend.
│    │   ├── main.tf        # Configuración principal de Terraform para Azure.
│    │   ├── variables.tf   # Variables utilizadas en Terraform.
│    │   └── outputs.tf     # Salidas del estado de Terraform.
│    └── gcp/
|        ├── backend.tf          # Configuración del backend.
│        ├── main.tf        # Configuración principal de Terraform para GCP.
│        ├── variables.tf   # Variables utilizadas en Terraform.
│        └── outputs.tf     # Salidas del estado de Terraform.
├── scripts/
|    ├── deploy_gcp.sh      # Script de despliegue para GCP.
│    ├── deploy_aws.sh      # Script de despliegue para AWS.
│    └── deploy_azure.sh    # Script de despliegue para Azure.
├── .github/workflows/
│    └── ci-cd.yml          # Archivo de configuración del pipeline de GitHub Actions.
├── README.md               # Documentación del proyecto.
└── LICENSE                 # Licencia del proyecto.
```

```
┌────────────────────────────────────────────────────────────┐
│                     GitHub Repository                      │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Infrastructure Code (Terraform)              │  │
│  │  • terraform/aws/     • terraform/azure/             │  │
│  │  • terraform/gcp/     • scripts/                     │  │
│  └──────────────────────────────────────────────────────┘  │
└──────────────────────┬─────────────────────────────────────┘
                       │ Git Push / Manual Trigger
                       ▼
┌───────────────────────────────────────────────────────────┐
│                   GitHub Actions Runner                   │
│  ┌─────────────────────────────────────────────────────┐  │
│  │  1. Validate Cloud Provider & Credentials           │  │
│  │  2. Setup Terraform & Cloud CLI                     │  │
│  │  3. Initialize Terraform (with remote backend)      │  │
│  │  4. Plan Infrastructure Changes                     │  │
│  │  5. Apply Changes (create/update resources)         │  │
│  │  6. Execute Deployment Scripts                      │  │
│  └─────────────────────────────────────────────────────┘  │
└──────────────┬────────────┬────────────┬──────────────────┘
               │            │            │
               ▼            ▼            ▼
       ┌───────────┐  ┌───────────┐  ┌───────────┐
       │    AWS    │  │   Azure   │  │    GCP    │
       │ Resources │  │ Resources │  │ Resources │
       └───────────┘  └───────────┘  └───────────┘
```

---

# 🎯 Pipeline de CI/CD

El pipeline sigue los siguientes pasos:

  - Checkout del Código: Clona el repositorio en el entorno de GitHub Actions.
  - Configuración de Terraform: Instala Terraform y configura el entorno.
  - Autenticación con GCP: Valida y autentica las credenciales de GCP.
  - Inicialización de Terraform: Inicializa el backend y descarga los plugins necesarios.
  - Planificación y Aplicación: Genera un plan de cambios y aplica la infraestructura.
  - Clonación del Repositorio del Proyecto: Clona el repositorio del proyecto principal.
  - Despliegue Final: Ejecuta scripts específicos según el proveedor de nube.

---

# 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si deseas mejorar este proyecto, sigue estos pasos:

  1. Haz un fork del repositorio.
   
  2. Crea una nueva rama:
    ```bash
    git checkout -b feature/nueva-funcionalidad
    ```

  3. Realiza tus cambios y haz commit:
    ```bash
    git commit -m "feat: Añadir nueva funcionalidad"
    ```

  4. Sube tus cambios:
    ```bash
    git push origin feature/nueva-funcionalidad
    ```

  5. Abre un Pull Request.
    
Convenciones de commits:

- `feat`: Nueva funcionalidad
- `fix`: Corrección de bugs
- `docs`: Cambios en documentación
- `refactor`: Refactorización de código
- `test`: Añadir o modificar tests

---

# 📄 Licencia

Este proyecto está bajo los términos de la licencia [MIT](./LICENSE).

---

**⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub!**