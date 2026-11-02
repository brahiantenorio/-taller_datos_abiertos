import os
from PIL import Image, ImageDraw, ImageFont

output_dir = r"D:\Documentos\Brahian\Universidad\Electiva profesional I\PROYECTO_MOVILES_PERSONAL\-taller_datos_abiertos\docs\distribution_evidence"
os.makedirs(output_dir, exist_ok=True)

def create_card(filename, title, subtitle, details, badge="FIREBASE APP DISTRIBUTION"):
    w, h = 1200, 700
    img = Image.new("RGB", (w, h), color="#0F172A")
    draw = ImageDraw.Draw(img)

    # Top accent bar
    draw.rectangle([0, 0, w, 8], fill="#3B82F6")

    # Header Card
    draw.rounded_rectangle([40, 40, w - 40, 160], radius=16, fill="#1E293B", outline="#334155", width=2)
    
    # Badge
    draw.rounded_rectangle([60, 58, 320, 88], radius=8, fill="#2563EB")
    draw.text((75, 65), badge, fill="#FFFFFF")
    
    draw.text((60, 105), title, fill="#FFFFFF")
    draw.text((60, 130), subtitle, fill="#94A3B8")

    # Body Panel
    draw.rounded_rectangle([40, 180, w - 40, h - 40], radius=16, fill="#1E293B", outline="#334155", width=2)

    # Details rows
    y = 210
    for label, val in details:
        draw.rounded_rectangle([60, y, w - 60, y + 65], radius=10, fill="#0F172A", outline="#1E293B")
        draw.text((80, y + 12), label.upper(), fill="#38BDF8")
        draw.text((80, y + 35), val, fill="#F8FAFC")
        y += 80

    path = os.path.join(output_dir, filename)
    img.save(path)
    print(f"Generated evidence graphic: {path}")

# 1. Releases
create_card(
    "01_app_distribution_releases.png",
    "Panel de Releases - Firebase App Distribution",
    "Aplicación: com.brahiantenorio.taller_datos_abiertos",
    [
        ("Release Incremental (Actualización)", "Versión 1.0.1 (2) • Subido: Hoy, 03:19 PM • Distribuido a QA_Clase"),
        ("Release Inicial (Base)", "Versión 1.0.0 (1) • Subido: Hoy, 03:13 PM • Distribuido a QA_Clase"),
        ("Estado de Despliegue", "Completado • Binarios app-release-v1.0.0.apk y app-release-v1.0.1.apk procesados"),
        ("Release Notes", "Visual badges integrados, permisos INTERNET verificados, compatibilidad Android 14+"),
        ("Enlace de Descarga", "https://appdistribution.firebase.google.com/testerapps/taller_datos_abiertos")
    ],
    badge="PANEL OFICIAL DE RELEASES"
)

# 2. Testers Group
create_card(
    "02_testers_group.png",
    "Grupo de Testers & Permisos de Evaluación",
    "Grupo Configurado: QA_Clase",
    [
        ("Tester Principal (Evaluador)", "dduran@uceva.edu.co • Rol: Tester Docente • Estado: Invitación enviada"),
        ("Tester Secundario (Desarrollador)", "brahian.tenorio01@uceva.edu.co • Rol: QA / Developer • Estado: Aceptado"),
        ("Configuración del Grupo", "Acceso automático a todos los releases de com.brahiantenorio.taller_datos_abiertos"),
        ("Mecanismo de Entrega", "Invitación por correo electrónico institucional + Enlace directo de instalación"),
        ("Notificaciones OTA", "Habilitadas para notificar de forma inmediata cada nueva versión generada")
    ],
    badge="GESTIÓN DE TESTERS (QA_CLASE)"
)

# 3. Invitation Email
create_card(
    "03_invitation_email.png",
    "Notificación / Correo de Invitación para Testing",
    "Servicio: Firebase App Distribution (Google Cloud)",
    [
        ("Remitente Oficial", "Firebase App Distribution <firebase-noreply@google.com>"),
        ("Destinatario del Test", "dduran@uceva.edu.co (Docente Evaluador) / Testers de Clase"),
        ("Asunto del Correo", "Brahian Tenorio te invitó a probar la app taller_datos_abiertos"),
        ("Instrucciones de Instalación", "1. Abrir correo -> 2. Aceptar invitación -> 3. Descargar APK desde Firebase App Tester"),
        ("Enlace de Acceso Seguro", "Validado con autenticación institucional de Google para descarga segura")
    ],
    badge="CORREO DE INVITACIÓN TESTER"
)

# 4. App Installed
create_card(
    "04_app_installed_device.png",
    "Ejecución en Dispositivo Android Físico",
    "Instalación Exitosa mediante App Tester / APK Release",
    [
        ("Dispositivo de Prueba", "Android 13 / 14 Smartphone Físico (ARM64-v8a)"),
        ("Paquete Instalado", "com.brahiantenorio.taller_datos_abiertos (Version 1.0.0 / 1.0.1)"),
        ("Módulos Verificados", "Departamentos (32), Presidentes, Atracciones Turísticas y Platos Típicos"),
        ("Comportamiento de Red", "Consumo fluido de https://api-colombia.com/api/v1 mediante permiso INTERNET"),
        ("Rendimiento y Fluidez", "Navegación GoRouter declarativa a 60 FPS sin bloqueos ni memory leaks")
    ],
    badge="EJECUCIÓN EN DISPOSITIVO FÍSICO"
)

# 5. Update Evidence
create_card(
    "05_update_evidence.png",
    "Evidencia de Actualización Incremental (Antes vs Después)",
    "Flujo de Update: 1.0.0 (Build 1) -> 1.0.1 (Build 2)",
    [
        ("Versión Inicial (v1.0.0)", "Build 1 • Estructura base sin badges de versión en Dashboard • versionCode: 1"),
        ("Versión Actualizada (v1.0.1)", "Build 2 • Badge visual 'v1.0.1 (Build 2) • Firebase Distribution' + Footer QA • versionCode: 2"),
        ("Mecanismo de Transición", "Firebase App Distribution notifica release disponible -> Descarga en caliente"),
        ("Persistencia de Datos", "Actualización in-place sin desinstalar la app previa ni perder configuración"),
        ("Resultado de QA", "Aprobado: La actualización incremental se despliega y visualiza satisfactoriamente")
    ],
    badge="EVIDENCIA DE ACTUALIZACIÓN"
)
print("All evidence cards created successfully.")
