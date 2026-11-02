# Pull Request: Distribución de APK con Firebase App Distribution

## 📌 Rama Origen y Destino
- **Origen (Head):** `feature/app_distribution`
- **Destino (Base):** `dev`
- **Integración Final:** `main` (Release de producción v1.0.1)

---

## 🎯 Descripción General
Este Pull Request implementa la infraestructura, configuraciones técnicas de Android, versionado incremental y documentación completa para el **Taller 1: Distribución de APK con Firebase App Distribution** de la asignatura **Electiva Profesional I (Móviles con Flutter)** en la **UCEVA**.

---

## 🛠️ Cambios Realizados

### 1. Configuración de Android y Permisos de Red
- Inclusión de permisos explícitos en `android/app/src/main/AndroidManifest.xml`:
  - `<uses-permission android:name="android.permission.INTERNET"/>`
  - `<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>`
- Verificación del `signingConfig` en `android/app/build.gradle.kts` para permitir instalación universal del APK release firmado en dispositivos de prueba externos.

### 2. Versionado Semántico Incremental (OTA)
- **Versión 1.0.0+1:** Release base inicial generado en `releases/v1.0.0/app-release-v1.0.0.apk`.
- **Versión 1.0.1+2:** Release de actualización incremental generado en `releases/v1.0.1/app-release-v1.0.1.apk`.
- Incorporación de elementos visuales diferenciadores en `DashboardView`:
  - Badge dinámico en cabecera: `v1.0.1 (Build 2) • Firebase Distribution`.
  - Chip identificador en footer: `Release v1.0.1+2 | QA_Clase Tester Build`.

### 3. Pipeline de Distribución en Firebase Console
- Identificador de aplicación: `com.brahiantenorio.taller_datos_abiertos`.
- Grupo de evaluadores: **`QA_Clase`**.
- Evaluador institucional asignado: **`dduran@uceva.edu.co`**.
- Release Notes estructuradas para ambas versiones.

### 4. Documentación y Entregables
- Actualización de `README.md` con flujo de publicación, replicación de despliegue y bitácora de QA.
- Creación de script generador de informe técnico `scripts/generate_app_distribution_pdf.py` con ReportLab.
- Generación del informe oficial en PDF: `Informe_Firebase_App_Distribution_Brahian_Tenorio.pdf` (incluye URL del repositorio en la primera página).
- Creación del archivo de texto requerido: `entrega_app_distribution.txt` con enlaces y release notes.
- Generación de tarjetas y capturas de evidencias en `docs/distribution_evidence/`.

---

## 🧪 Pruebas y Validación de Calidad
- [x] **`flutter analyze`:** 0 errores, 0 warnings (100% limpio).
- [x] **`flutter test`:** 10/10 pruebas unitarias y de widgets aprobadas.
- [x] **`flutter build apk --release`:** Compilación exitosa de ambas versiones (48.8 MB c/u).
- [x] **Instalación en Hardware Real:** Verificada en smartphone Android físico.

---

**Autor:** Brahian Steven Tenorio  
**Docente:** Ing. Diego Fernando Durán (`dduran@uceva.edu.co`)  
**Fecha:** 02 de Noviembre de 2026
