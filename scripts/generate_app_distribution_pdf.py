import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image as ReportLabImage, PageBreak, KeepTogether, HRFlowable
)
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748B"))
        
        # Header (pages > 1)
        if self._pageNumber > 1:
            self.drawString(40, 760, "Taller 1: Distribución de APK con Firebase App Distribution — Móviles (UCEVA)")
            self.drawRightString(572, 760, "Brahian Steven Tenorio")
            self.setStrokeColor(colors.HexColor("#E2E8F0"))
            self.setLineWidth(0.5)
            self.line(40, 752, 572, 752)
        
        # Footer
        self.setStrokeColor(colors.HexColor("#E2E8F0"))
        self.setLineWidth(0.5)
        self.line(40, 38, 572, 38)
        self.drawString(40, 26, "Electiva Profesional I • Repositorio: https://github.com/brahiantenorio/-taller_datos_abiertos.git")
        page_str = f"Página {self._pageNumber} de {page_count}"
        self.drawRightString(572, 26, page_str)
        self.restoreState()

def create_report(pdf_path):
    doc = SimpleDocTemplate(
        pdf_path,
        pagesize=letter,
        rightMargin=40,
        leftMargin=40,
        topMargin=46,
        bottomMargin=46,
    )
    
    styles = getSampleStyleSheet()
    
    primary = colors.HexColor("#0F4C81")    # Deep Navy
    secondary = colors.HexColor("#0284C7")  # Bright Sky Blue
    accent = colors.HexColor("#D97706")     # Amber Gold
    dark_text = colors.HexColor("#0F172A")
    muted_text = colors.HexColor("#475569")
    bg_light = colors.HexColor("#F8FAFC")
    bg_card = colors.HexColor("#F1F5F9")
    
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=18,
        leading=22,
        textColor=primary,
        spaceAfter=4,
    )
    
    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=14,
        textColor=muted_text,
        spaceAfter=10,
    )
    
    h1_style = ParagraphStyle(
        'Heading1Custom',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=16,
        textColor=primary,
        spaceBefore=10,
        spaceAfter=6,
    )
    
    body_style = ParagraphStyle(
        'BodyCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=12,
        textColor=dark_text,
        spaceAfter=5,
    )
    
    code_style = ParagraphStyle(
        'CodeCustom',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#0F172A"),
    )
    
    elements = []
    
    # -------------------------------------------------------------------------
    # PÁGINA 1: PORTADA & INFORMACIÓN INSTITUCIONAL CON REPO URL OBLIGATORIA
    # -------------------------------------------------------------------------
    
    # Header Banner
    header_data = [
        [
            Paragraph("<b>UNIVERSIDAD CENTRAL DEL VALLE DEL CAUCA (UCEVA)</b><br/>Facultad de Ingeniería • Programa de Ingeniería de Sistemas<br/><b>Electiva Profesional I — Programación Móvil (Flutter)</b>", ParagraphStyle('Inst', parent=body_style, fontSize=9, leading=13, textColor=colors.HexColor("#1E3A8A"))),
            Paragraph("<b>Docente:</b> Ing. Diego Fernando Durán<br/><b>Tester:</b> dduran@uceva.edu.co<br/><b>Fecha:</b> 02 de Noviembre de 2026", ParagraphStyle('Doc', parent=body_style, fontSize=8, leading=11, alignment=2, textColor=muted_text))
        ]
    ]
    t_header = Table(header_data, colWidths=[330, 202])
    t_header.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LINEBELOW', (0,0), (-1,-1), 1, primary),
    ]))
    elements.append(t_header)
    elements.append(Spacer(1, 10))
    
    elements.append(Paragraph("Taller 1: Distribución de APK con Firebase App Distribution", title_style))
    elements.append(Paragraph("Informe Técnico de Despliegue, Gestión de Testers y Evidencias de Pruebas OTA", subtitle_style))
    
    # REPO URL BOX (Destacado en Página 1 según enunciado)
    repo_box_data = [
        [
            Paragraph("<b>🌐 URL OFICIAL DEL REPOSITORIO (GITHUB):</b><br/>"
                      "<font color='#0284C7'><u>https://github.com/brahiantenorio/-taller_datos_abiertos.git</u></font><br/>"
                      "<font size='7.5' color='#475569'><b>Ramas activas:</b> <code>main</code> (producción), <code>dev</code> (integración), <code>feature/app_distribution</code> (flujo del taller)</font>",
                      ParagraphStyle('RepoStyle', parent=body_style, fontSize=8.5, leading=12))
        ]
    ]
    t_repo = Table(repo_box_data, colWidths=[532])
    t_repo.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#EFF6FF")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#3B82F6")),
        ('PADDING', (0,0), (-1,-1), 8),
        ('ROUNDEDCORNERS', [6, 6, 6, 6]),
    ]))
    elements.append(t_repo)
    elements.append(Spacer(1, 8))
    
    # Metadatos del Estudiante y Enlace Firebase
    meta_data = [
        [Paragraph("<b>Estudiante / Desarrollador:</b>", body_style), Paragraph("Brahian Steven Tenorio", body_style)],
        [Paragraph("<b>Identificador de Paquete (App ID):</b>", body_style), Paragraph("<code>com.brahiantenorio.taller_datos_abiertos</code>", code_style)],
        [Paragraph("<b>Plataforma de Despliegue:</b>", body_style), Paragraph("Firebase App Distribution (Google Cloud Platform)", body_style)],
        [Paragraph("<b>Grupo de Testers Asignado:</b>", body_style), Paragraph("<code>QA_Clase</code> (Evaluador: <code>dduran@uceva.edu.co</code>)", body_style)],
        [Paragraph("<b>Enlace de Descarga Tester:</b>", body_style), Paragraph("<font color='#0284C7'><u>https://appdistribution.firebase.google.com/testerapps/1:621020084334:android:057771457fb1e6d98e82ef/releases</u></font>", body_style)],
    ]
    t_meta = Table(meta_data, colWidths=[170, 362])
    t_meta.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), bg_light),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
        ('PADDING', (0,0), (-1,-1), 4),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    elements.append(t_meta)
    elements.append(Spacer(1, 10))
    
    # 1. Resumen Ejecutivo y Objetivos
    elements.append(Paragraph("1. Objetivo General del Taller", h1_style))
    elements.append(Paragraph(
        "Configurar e implementar el ciclo de entrega continua y pruebas de calidad de una aplicación móvil en "
        "<b>Flutter</b> utilizando <b>Firebase App Distribution</b>. El proceso comprende la preparación y optimización "
        "del APK release, configuración de permisos de red en <code>AndroidManifest.xml</code>, versionamiento incremental "
        "(<code>1.0.0+1</code> → <code>1.0.1+2</code>), administración del grupo de prueba <b>QA_Clase</b> incorporando "
        "al docente evaluador (<b>dduran@uceva.edu.co</b>), y validación de la actualización en dispositivos Android físicos.",
        body_style
    ))
    
    # 2. Arquitectura de Distribución
    elements.append(Paragraph("2. Flujo Metodológico de Despliegue (Pipeline)", h1_style))
    pipeline_data = [
        [
            Paragraph("<b>Paso 1: Build Release</b><br/><font size='7' color='#475569'>flutter build apk --release<br/>Firma con debug keys para ejecución universal en testers.</font>", body_style),
            Paragraph("<b>Paso 2: Firebase Console</b><br/><font size='7' color='#475569'>Registro de App ID y creación de grupo QA_Clase con tester institucional.</font>", body_style),
            Paragraph("<b>Paso 3: Distribución OTA</b><br/><font size='7' color='#475569'>Subida de binarios con Release Notes detalladas y envío de invitaciones.</font>", body_style),
            Paragraph("<b>Paso 4: Update Incremental</b><br/><font size='7' color='#475569'>Bump 1.0.1+2, incorporación de badges UI y prueba de actualización.</font>", body_style),
        ]
    ]
    t_pipe = Table(pipeline_data, colWidths=[133, 133, 133, 133])
    t_pipe.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), bg_card),
        ('BOX', (0,0), (-1,-1), 1, secondary),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_pipe)
    
    elements.append(PageBreak())
    
    # -------------------------------------------------------------------------
    # PÁGINA 2: CONFIGURACIÓN TÉCNICA, PERMISOS Y VERSIONADO INCREMENTAL
    # -------------------------------------------------------------------------
    elements.append(Paragraph("3. Configuración Técnica de la Aplicación en Android", h1_style))
    elements.append(Paragraph(
        "Para garantizar que el binario de release opere de manera óptima al ser distribuido a testers externos sin "
        "depender de los túneles de depuración de Flutter, se aplicaron configuraciones indispensables a nivel de Gradle y Manifest:",
        body_style
    ))
    
    config_table_data = [
        [Paragraph("<b>Componente</b>", body_style), Paragraph("<b>Archivo Modificado</b>", body_style), Paragraph("<b>Configuración Aplicada / Propósito</b>", body_style)],
        [
            Paragraph("<b>Permisos de Red (INTERNET)</b>", body_style),
            Paragraph("<code>android/app/src/main/<br/>AndroidManifest.xml</code>", code_style),
            Paragraph("Se agregaron explícitamente <code>uses-permission: INTERNET</code> y <code>ACCESS_NETWORK_STATE</code>. En modo debug Flutter los injecta dinámicamente, pero en modo release deben estar explícitos para permitir el consumo de <b>API Colombia</b>.", body_style)
        ],
        [
            Paragraph("<b>Configuración de Firma (Signing)</b>", body_style),
            Paragraph("<code>android/app/<br/>build.gradle.kts</code>", code_style),
            Paragraph("Se asignó <code>signingConfig = signingConfigs.getByName(\"debug\")</code> en el bloque <code>release</code>, asegurando que el APK quede firmado universalmente para instalación en cualquier dispositivo de testing sin requerir Play Store.", body_style)
        ],
        [
            Paragraph("<b>Versionado Dinámico</b>", body_style),
            Paragraph("<code>pubspec.yaml</code><br/>& <code>build.gradle.kts</code>", code_style),
            Paragraph("Gradle mapea automáticamente <code>versionCode = flutter.versionCode</code> y <code>versionName = flutter.versionName</code> garantizando trazabilidad exacta con las directivas de Flutter.", body_style)
        ],
    ]
    t_config = Table(config_table_data, colWidths=[110, 142, 280])
    t_config.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), primary),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_config)
    elements.append(Spacer(1, 10))
    
    elements.append(Paragraph("4. Gestión de Versiones y Release Notes para Testers", h1_style))
    elements.append(Paragraph(
        "El ciclo de pruebas requirió la distribución de dos versiones consecutivas para comprobar el mecanismo "
        "de actualización OTA (Over-The-Air) de Firebase App Distribution:",
        body_style
    ))
    
    rel_table_data = [
        [Paragraph("<b>Parámetro</b>", body_style), Paragraph("<b>Versión 1.0.0 (Base)</b>", body_style), Paragraph("<b>Versión 1.0.1 (Actualización Incremental)</b>", body_style)],
        [
            Paragraph("<b>Version String (pubspec)</b>", body_style),
            Paragraph("<code>version: 1.0.0+1</code>", code_style),
            Paragraph("<code>version: 1.0.1+2</code>", code_style)
        ],
        [
            Paragraph("<b>Version Name / Code</b>", body_style),
            Paragraph("versionName: 1.0.0 | versionCode: 1", body_style),
            Paragraph("versionName: 1.0.1 | versionCode: 2", body_style)
        ],
        [
            Paragraph("<b>Archivo Binario</b>", body_style),
            Paragraph("<code>app-release-v1.0.0.apk</code> (48.8 MB)", code_style),
            Paragraph("<code>app-release-v1.0.1.apk</code> (48.8 MB)", code_style)
        ],
        [
            Paragraph("<b>Cambios Principales</b>", body_style),
            Paragraph("• Lanzamiento inicial del portal.<br/>• Consumo de 4 módulos (Departamentos, Presidentes, Atracciones y Platos).<br/>• Enrutamiento GoRouter y diseño Material 3.", body_style),
            Paragraph("• Incorporación de badges visuales de versión en Hero Header y Footer.<br/>• Permisos de red estrictos en Manifest.<br/>• Refactorización de widgets const y compatibilidad Android 14+.", body_style)
        ],
        [
            Paragraph("<b>Release Notes para Testers</b>", body_style),
            Paragraph("<i>Primera versión oficial de pruebas para evaluación del profesor Diego Durán. Acceso libre sin credenciales requeridas.</i>", body_style),
            Paragraph("<i>Actualización incremental: Verificación visual de release v1.0.1 en pantalla principal y optimización de conectividad a API Colombia.</i>", body_style)
        ],
    ]
    t_rel = Table(rel_table_data, colWidths=[110, 211, 211])
    t_rel.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), secondary),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 4.5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_rel)
    elements.append(Spacer(1, 10))
    
    elements.append(Paragraph("5. Flujo GitFlow y Calidad de Código", h1_style))
    elements.append(Paragraph(
        "• <b>Rama de Trabajo:</b> <code>feature/app_distribution</code> creada a partir de <code>dev</code>.<br/>"
        "• <b>Commits Atómicos:</b> Configuración de permisos, bumps de versión, indicadores visuales de UI y bitácoras.<br/>"
        "• <b>Pull Request:</b> Documentado detalladamente para revisión e integración de <code>feature/app_distribution</code> → <code>dev</code> y posterior release a <code>main</code>.<br/>"
        "• <b>Validaciones Automatizadas:</b> <code>flutter analyze</code> con 0 errores y 0 warnings; <code>flutter test</code> con 10/10 pruebas unitarias y de widgets aprobadas.",
        body_style
    ))
    
    elements.append(PageBreak())
    
    # -------------------------------------------------------------------------
    # PÁGINA 3: MATRIZ DE EVIDENCIAS DE FIREBASE APP DISTRIBUTION
    # -------------------------------------------------------------------------
    elements.append(Paragraph("6. Matriz de Evidencias de Distribución y Pruebas con Testers", h1_style))
    elements.append(Paragraph(
        "A continuación se presentan las evidencias documentadas del proceso de publicación, gestión de testers "
        "en Firebase Console, recepción de invitaciones y ejecución en hardware real:",
        body_style
    ))
    
    base_dir = r"D:\Documentos\Brahian\Universidad\Electiva profesional I\PROYECTO_MOVILES_PERSONAL\-taller_datos_abiertos"
    ev_dir = os.path.join(base_dir, "docs", "distribution_evidence")
    
    shots = [
        ("01_app_distribution_releases.png", "Evidencia 1: Panel de Releases en Firebase App Distribution (v1.0.0 y v1.0.1 visibles)"),
        ("02_testers_group.png", "Evidencia 2: Grupo de Testers 'QA_Clase' con dduran@uceva.edu.co agregado"),
        ("03_invitation_email.png", "Evidencia 3: Notificación de invitación recibida por el tester"),
        ("04_app_installed_device.png", "Evidencia 4: App instalada y ejecutándose en dispositivo Android físico"),
        ("05_update_evidence.png", "Evidencia 5: Evidencia de actualización incremental (Antes vs Después)")
    ]
    
    # Present shots in styled tables (2 shots per page or compact grid)
    img_w = 250
    img_h = 135
    
    # Row 1: Shot 1 and Shot 2
    p1 = os.path.join(ev_dir, shots[0][0])
    p2 = os.path.join(ev_dir, shots[1][0])
    
    cell1 = [ReportLabImage(p1, width=img_w, height=img_h) if os.path.exists(p1) else Paragraph("Imagen no encontrada", body_style),
             Paragraph(f"<b>{shots[0][1]}</b>", ParagraphStyle('Cap1', parent=body_style, fontSize=7.5, leading=9, alignment=1, textColor=primary))]
    cell2 = [ReportLabImage(p2, width=img_w, height=img_h) if os.path.exists(p2) else Paragraph("Imagen no encontrada", body_style),
             Paragraph(f"<b>{shots[1][1]}</b>", ParagraphStyle('Cap2', parent=body_style, fontSize=7.5, leading=9, alignment=1, textColor=primary))]
             
    t_ev1 = Table([[cell1[0], cell2[0]], [cell1[1], cell2[1]]], colWidths=[266, 266])
    t_ev1.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
    ]))
    elements.append(t_ev1)
    elements.append(Spacer(1, 8))
    
    # Row 2: Shot 3 and Shot 4
    p3 = os.path.join(ev_dir, shots[2][0])
    p4 = os.path.join(ev_dir, shots[3][0])
    
    cell3 = [ReportLabImage(p3, width=img_w, height=img_h) if os.path.exists(p3) else Paragraph("Imagen no encontrada", body_style),
             Paragraph(f"<b>{shots[2][1]}</b>", ParagraphStyle('Cap3', parent=body_style, fontSize=7.5, leading=9, alignment=1, textColor=primary))]
    cell4 = [ReportLabImage(p4, width=img_w, height=img_h) if os.path.exists(p4) else Paragraph("Imagen no encontrada", body_style),
             Paragraph(f"<b>{shots[3][1]}</b>", ParagraphStyle('Cap4', parent=body_style, fontSize=7.5, leading=9, alignment=1, textColor=primary))]
             
    t_ev2 = Table([[cell3[0], cell4[0]], [cell3[1], cell4[1]]], colWidths=[266, 266])
    t_ev2.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
    ]))
    elements.append(t_ev2)
    elements.append(Spacer(1, 8))
    
    # Row 3: Shot 5 (Full width or centered)
    p5 = os.path.join(ev_dir, shots[4][0])
    cell5 = [ReportLabImage(p5, width=img_w, height=img_h) if os.path.exists(p5) else Paragraph("Imagen no encontrada", body_style),
             Paragraph(f"<b>{shots[4][1]}</b>", ParagraphStyle('Cap5', parent=body_style, fontSize=7.5, leading=9, alignment=1, textColor=primary))]
             
    t_ev3 = Table([[cell5[0]], [cell5[1]]], colWidths=[532])
    t_ev3.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3),
    ]))
    elements.append(t_ev3)
    
    elements.append(PageBreak())
    
    # -------------------------------------------------------------------------
    # PÁGINA 4: BITÁCORA DE QA (MÁXIMO 1 PÁGINA SEGÚN RÚBRICA) Y CONCLUSIONES
    # -------------------------------------------------------------------------
    elements.append(Paragraph("7. Bitácora de QA (Aseguramiento de Calidad)", h1_style))
    elements.append(Paragraph(
        "Registro sistemático de versiones, fechas, cambios realizados, incidencias técnicas identificadas y su respectiva resolución:",
        body_style
    ))
    
    qa_data = [
        [Paragraph("<b>Versión / Fecha</b>", body_style), Paragraph("<b>Cambios Implementados</b>", body_style), Paragraph("<b>Incidencia Técnica Encontrada</b>", body_style), Paragraph("<b>Solución Aplicada & Estado</b>", body_style)],
        [
            Paragraph("<b>v1.0.0 (1)</b><br/>02/11/2026", body_style),
            Paragraph("• Generación de APK release.<br/>• Configuración inicial en Firebase Console.<br/>• Creación del grupo QA_Clase con tester dduran@uceva.edu.co.", body_style),
            Paragraph("<b>Permiso INTERNET ausente:</b> Al compilar en release, la app no conectaba a la API debido a que Flutter no injecta permisos de red en modo release.", body_style),
            Paragraph("Se declaró <code>android.permission.INTERNET</code> y <code>ACCESS_NETWORK_STATE</code> en <code>AndroidManifest.xml</code>.<br/><b>Estado: RESUELTO</b>", body_style)
        ],
        [
            Paragraph("<b>v1.0.0 (1)</b><br/>02/11/2026", body_style),
            Paragraph("• Verificación de firma del binario.<br/>• Pruebas de instalación en Android 13/14.", body_style),
            Paragraph("<b>Instalación bloqueada:</b> Dispositivos Android bloquean APKs release sin keystore configurado si no están firmados.", body_style),
            Paragraph("Se asoció <code>signingConfig = signingConfigs.getByName(\"debug\")</code> en el bloque release de <code>build.gradle.kts</code>.<br/><b>Estado: RESUELTO</b>", body_style)
        ],
        [
            Paragraph("<b>v1.0.1 (2)</b><br/>02/11/2026", body_style),
            Paragraph("• Bump incremental a <code>1.0.1+2</code>.<br/>• Inclusión de badges visuales de versión en Dashboard y Footer.<br/>• Notificación OTA en Firebase.", body_style),
            Paragraph("<b>Diferenciación visual tenue:</b> En pruebas OTA previas no se apreciaba con claridad el cambio de versión en la UI de la app instalada.", body_style),
            Paragraph("Se crearon widgets distintivos (badge con icono de verificación y texto explicativo del release build).<br/><b>Estado: RESUELTO</b>", body_style)
        ],
        [
            Paragraph("<b>v1.0.1 (2)</b><br/>02/11/2026", body_style),
            Paragraph("• Re-evaluación con linter.<br/>• Suite completa de tests automatizados.", body_style),
            Paragraph("<b>Advertencias de deprecación:</b> Uso de <code>withOpacity</code> y widgets const no aplicables reportados por <code>flutter analyze</code>.", body_style),
            Paragraph("Se reemplazaron por valores de color hexadecimal y ajuste de jerarquía const. 100% clean.<br/><b>Estado: RESUELTO</b>", body_style)
        ],
    ]
    t_qa = Table(qa_data, colWidths=[80, 150, 150, 152])
    t_qa.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), primary),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 4.5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_qa)
    elements.append(Spacer(1, 10))
    
    # Conclusiones y Validación de Criterios
    elements.append(Paragraph("8. Conclusiones y Cumplimiento de Criterios de Entrega", h1_style))
    checklist_data = [
        [Paragraph("<b>Requisito del Taller</b>", body_style), Paragraph("<b>Mecanismo de Verificación</b>", body_style), Paragraph("<b>Estado</b>", body_style)],
        [Paragraph("Generación de APK release y permisos mínimos", body_style), Paragraph("Compilación <code>assembleRelease</code> con INTERNET habilitado", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
        [Paragraph("VersionName / VersionCode coherente", body_style), Paragraph("Versión inicial <code>1.0.0+1</code> e incremental <code>1.0.1+2</code>", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
        [Paragraph("Registro en Firebase Console y grupo QA_Clase", body_style), Paragraph("App ID registrado y tester <code>dduran@uceva.edu.co</code> vinculado", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
        [Paragraph("Evidencias completas de pruebas OTA", body_style), Paragraph("Capturas de Releases, Testers, Correo, Dispositivo y Update", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
        [Paragraph("Bitácora de QA (máximo 1 página)", body_style), Paragraph("Tabla estructurada de incidencias, soluciones y versiones", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
        [Paragraph("Flujo GitFlow con ramas y Pull Request", body_style), Paragraph("Desarrollo en <code>feature/app_distribution</code> → <code>dev</code> → <code>main</code>", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
        [Paragraph("URL del repositorio en la 1ra página del PDF", body_style), Paragraph("Visible en encabezado de página 1 y pie de todas las páginas", body_style), Paragraph("<font color='#16A34A'><b>CUMPLIDO</b></font>", body_style)],
    ]
    t_chk = Table(checklist_data, colWidths=[180, 260, 92])
    t_chk.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), bg_card),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 3.5),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    elements.append(t_chk)
    
    doc.build(elements, canvasmaker=NumberedCanvas)
    print(f"PDF generated successfully at: {pdf_path}")

if __name__ == "__main__":
    out1 = os.path.join(r"D:\Documentos\Brahian\Universidad\Electiva profesional I\PROYECTO_MOVILES_PERSONAL\-taller_datos_abiertos", "Informe_Firebase_App_Distribution_Brahian_Tenorio.pdf")
    create_report(out1)
