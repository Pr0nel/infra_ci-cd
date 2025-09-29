# Infra CI/CD Pipeline

[GitHub Actions](https://img.shields.io/github/actions/workflow/status/Pr0nel/infra_ci-cd/ci-cd.yml?label=CI/CD&logo=github) [Terraform](https://img.shields.io/badge/Terraform-1.5+-purple.svg) [Cloud](https://img.shields.io/badge/Cloud-AWS%20%7C%20Azure%20%7C%20GCP-blue.svg)

Este repositorio contiene la infraestructura como código (IaC) y el pipeline de CI/CD para desplegar recursos en múltiples proveedores de nube (GCP, AWS, Azure). Utiliza Terraform para gestionar la infraestructura y GitHub Actions para automatizar el proceso de implementación.

---

- [Infra CI/CD Pipeline](#infra-cicd-pipeline)
- [Descripción del Proyecto](#descripción-del-proyecto)
- [Características Principales](#características-principales)
- [Requisitos Previos](#requisitos-previos)
  - [Software](#software)
  - [Conocimientos](#conocimientos)
- [Configuración del Proyecto](#configuración-del-proyecto)
  - [1. Configuración de Secrets en GitHub Actions](#1-configuración-de-secrets-en-github-actions)
  - [2. Ejecución del Pipeline](#2-ejecución-del-pipeline)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Pipeline de CI/CD](#pipeline-de-cicd)
- [Contribuciones](#contribuciones)
  - [1. Haz un fork del repositorio.](#1-haz-un-fork-del-repositorio)
  - [2. Crea una nueva rama:](#2-crea-una-nueva-rama)
  - [3. Realiza tus cambios y haz commit:](#3-realiza-tus-cambios-y-haz-commit)
  - [4. Sube tus cambios:](#4-sube-tus-cambios)
  - [5. Abre un Pull Request.](#5-abre-un-pull-request)
- [Licencia](#licencia)

---

# Descripción del Proyecto

Este proyecto implementa un pipeline de CI/CD multi-nube que automatiza el despliegue de infraestructura utilizando:

  - Terraform para infraestructura como código (IaC)
  - GitHub Actions para automatización de CI/CD
  - Múltiples proveedores de nube (AWS, Azure, GCP)

El pipeline se encarga de validar, planificar y aplicar cambios en la infraestructura de manera segura y consistente, siguiendo las mejores prácticas de DevOps.

---

# Características Principales

🌐 Multi-Nube: Soporte completo para AWS, Azure y GCP.
🤖 Automatización: Pipeline completamente automatizado con GitHub Actions.
🔒 Seguridad: Gestión segura de credenciales mediante GitHub Secrets.
✅ Validación: Validación de credenciales, configuración y sintaxis antes de aplicar.
📦 Backend Remoto: State de Terraform persistente en la nube.
🔄 Idempotencia: Ejecuciones seguras y repetibles.
🚀 Escalabilidad: Diseñado para ser extensible y adaptable a diferentes entornos y proyectos.

---

# Requisitos Previos

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

# Configuración del Proyecto

## 1. Configuración de Secrets en GitHub Actions

Asegúrate de agregar los siguientes secrets en Settings > Secrets and variables > Actions de tu repositorio de GitHub:

    Secrets comunes
      - CLOUD_PROVIDER: Proveedor de nube (gcp, aws, azure).
      - TF_VAR_REGION: Región de GCP donde se desplegarán los recursos.
      - TF_VAR_BUCKET_NAME: Nombre único del bucket de almacenamiento.
    
    Secrets para AWS
      - AWS_ACCESS_KEY_ID: Access Key ID de IAM
      - AWS_SECRET_ACCESS_KEY: Secret Access Key
    
    Secrets para Azure
      - AZURE_CREDENTIALS: JSON del Service Principal
    
    Secrets para GCP
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

# Estructura del proyecto

![Estructura del proyecto](images/estructura_del_proyecto.png)

---

# Pipeline de CI/CD

El pipeline sigue los siguientes pasos:

  - Checkout del Código: Clona el repositorio en el entorno de GitHub Actions.
  - Configuración de Terraform: Instala Terraform y configura el entorno.
  - Autenticación con GCP: Valida y autentica las credenciales de GCP.
  - Inicialización de Terraform: Inicializa el backend y descarga los plugins necesarios.
  - Planificación y Aplicación: Genera un plan de cambios y aplica la infraestructura.
  - Clonación del Repositorio del Proyecto: Clona el repositorio del proyecto principal.
  - Despliegue Final: Ejecuta scripts específicos según el proveedor de nube.

---

# Contribuciones

¡Las contribuciones son bienvenidas! Si deseas mejorar este proyecto, sigue estos pasos:

## 1. Haz un fork del repositorio.
   
## 2. Crea una nueva rama:
    ```
    git checkout -b feature/nueva-funcionalidad
    ```

## 3. Realiza tus cambios y haz commit:
    ```
    git commit -m "feat: Añadir nueva funcionalidad"
    ```

## 4. Sube tus cambios:
    ```
    git push origin feature/nueva-funcionalidad
    ```

## 5. Abre un Pull Request.
    
Convenciones de commits:

    `feat`: Nueva funcionalidad
    `fix`: Corrección de bugs
    `docs`: Cambios en documentación
    `refactor`: Refactorización de código
    `test`: Añadir o modificar tests

---

# Licencia
    Este proyecto está bajo los términos de la licencia [MIT](LICENSE).

---

⭐ Si este proyecto te fue útil, considera darle una estrella en GitHub!