import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image as ReportLabImage, PageBreak, KeepTogether, HRFlowable
)

def create_report(pdf_path):
    doc = SimpleDocTemplate(
        pdf_path,
        pagesize=letter,
        rightMargin=40,
        leftMargin=40,
        topMargin=40,
        bottomMargin=40,
    )
    
    styles = getSampleStyleSheet()
    
    # Custom styles
    primary_color = colors.HexColor("#0F4C81")
    secondary_color = colors.HexColor("#F59E0B")
    accent_color = colors.HexColor("#DC2626")
    dark_text = colors.HexColor("#0F172A")
    muted_text = colors.HexColor("#475569")
    bg_light = colors.HexColor("#F8FAFC")
    
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=20,
        leading=24,
        textColor=primary_color,
        spaceAfter=6,
    )
    
    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        textColor=muted_text,
        spaceAfter=14,
    )
    
    h1_style = ParagraphStyle(
        'Heading1Custom',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=14,
        leading=18,
        textColor=primary_color,
        spaceBefore=14,
        spaceAfter=8,
    )
    
    h2_style = ParagraphStyle(
        'Heading2Custom',
        parent=styles['Heading3'],
        fontName='Helvetica-Bold',
        fontSize=11,
        leading=15,
        textColor=dark_text,
        spaceBefore=8,
        spaceAfter=4,
    )
    
    body_style = ParagraphStyle(
        'BodyCustom',
        parent=styles['BodyText'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=dark_text,
        spaceAfter=6,
    )
    
    bold_style = ParagraphStyle(
        'BoldCustom',
        parent=body_style,
        fontName='Helvetica-Bold',
    )
    
    code_style = ParagraphStyle(
        'CodeStyle',
        parent=body_style,
        fontName='Courier',
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor("#1E293B"),
    )
    
    elements = []
    
    # Header Banner Table
    banner_data = [
        [
            Paragraph("<b>INFORME TÉCNICO DE ENTREGABLE — TALLER 2DO CORTE</b><br/><font size='10' color='#64748B'>Electiva Profesional I — Móviles con Flutter</font>", ParagraphStyle('H', parent=title_style, fontSize=15, leading=18, textColor=primary_color)),
            Paragraph("<b>ESTUDIANTE:</b><br/>Brahian Andres Tenorio<br/><b>FECHA:</b> Octubre 2026", ParagraphStyle('R', parent=body_style, fontSize=9, leading=12, alignment=2))
        ]
    ]
    t_banner = Table(banner_data, colWidths=[350, 180])
    t_banner.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
    ]))
    elements.append(t_banner)
    elements.append(HRFlowable(width="100%", thickness=2, color=primary_color, spaceBefore=4, spaceAfter=12))
    
    # Repositorio y Ramas Box
    repo_data = [
        [Paragraph("<b>Repositorio Público GitHub:</b>", bold_style), Paragraph("<a href='https://github.com/brahiantenorio/-taller_datos_abiertos'><u>https://github.com/brahiantenorio/-taller_datos_abiertos</u></a>", body_style)],
        [Paragraph("<b>Ramas Implementadas:</b>", bold_style), Paragraph("<b>main</b> (producción estable)<br/><b>dev</b> (integración de desarrollo)<br/><b>feature/taller_api_colombia</b> (rama del taller)", body_style)],
        [Paragraph("<b>API Base Oficial:</b>", bold_style), Paragraph("<a href='https://api-colombia.com/'><u>https://api-colombia.com/api/v1</u></a> (Swagger: /swagger/index.html)", body_style)],
    ]
    t_repo = Table(repo_data, colWidths=[150, 380])
    t_repo.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), bg_light),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
        ('PADDING', (0,0), (-1,-1), 6),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    elements.append(t_repo)
    elements.append(Spacer(1, 10))
    
    # Resumen Ejecutivo
    elements.append(Paragraph("1. Resumen Ejecutivo del Proyecto", h1_style))
    elements.append(Paragraph(
        "El presente taller tuvo como objetivo diseñar y construir una aplicación móvil completa y escalable en Flutter "
        "que consume <b>4 endpoints oficiales de la API Pública de Colombia</b>. La aplicación implementa una separación por capas "
        "(Config, Models, Services, Routes, Themes, Views y Widgets), navegación declarativa avanzada mediante <b>go_router</b> "
        "con paso de parámetros tipados (patrón Maestro-Detalle), control estricto de estados asíncronos (cargando, éxito, error con reintento "
        "y estado vacío por filtrado) y buenas prácticas de código limpio auditadas con <i>flutter analyze</i> y pruebas automáticas con <i>flutter test</i>.",
        body_style
    ))
    
    # Endpoints implementados
    elements.append(Paragraph("2. Endpoints Consumidos (Mínimo 4 Requeridos)", h1_style))
    ep_data = [
        [Paragraph("<b>Endpoint</b>", bold_style), Paragraph("<b>Rutas API Consumidas</b>", bold_style), Paragraph("<b>Datos y Atributos Principales</b>", bold_style)],
        [
            Paragraph("<b>Departamentos</b>", bold_style),
            Paragraph("<font size='8'>GET /Department<br/>GET /Department/{id}</font>", code_style),
            Paragraph("Nombre, descripción, capital oficial, número de municipios, población, superficie (km²) y prefijo telefónico.", body_style)
        ],
        [
            Paragraph("<b>Presidentes</b>", bold_style),
            Paragraph("<font size='8'>GET /President<br/>GET /President/{id}</font>", code_style),
            Paragraph("Nombre, apellidos, fotografía oficial, partido político, fechas de inicio y fin de período, y biografía completa.", body_style)
        ],
        [
            Paragraph("<b>Atracciones Turísticas</b>", bold_style),
            Paragraph("<font size='8'>GET /TouristicAttraction<br/>GET /TouristicAttraction/{id}</font>", code_style),
            Paragraph("Nombre del destino, descripción histórica, galería de imágenes, coordenadas (latitud/longitud) y municipio.", body_style)
        ],
        [
            Paragraph("<b>Platos Típicos</b>", bold_style),
            Paragraph("<font size='8'>GET /TypicalDish<br/>GET /TypicalDish/{id}</font>", code_style),
            Paragraph("Nombre gastronómico, ingredientes detallados, departamento de origen, descripción tradicional y fotografía.", body_style)
        ],
    ]
    t_ep = Table(ep_data, colWidths=[110, 160, 260])
    t_ep.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0F4C81")),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, bg_light]),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_ep)
    elements.append(Spacer(1, 10))
    
    # Paquetes obligatorios
    elements.append(Paragraph("3. Paquetes Obligatorios Implementados", h1_style))
    pkg_data = [
        [Paragraph("<b>Paquete</b>", bold_style), Paragraph("<b>Versión</b>", bold_style), Paragraph("<b>Propósito y Justificación Técnica</b>", bold_style)],
        [Paragraph("<b>http</b>", bold_style), Paragraph("1.6.0", body_style), Paragraph("Consumo de peticiones REST GET, cabeceras Accept: application/json, validación de códigos de estado (200, 400, 404, 500), timeouts (15s) y decodificación UTF-8.", body_style)],
        [Paragraph("<b>go_router</b>", bold_style), Paragraph("18.1.1", body_style), Paragraph("Enrutamiento declarativo centralizado con rutas con nombre, rutas anidadas, extracción de parámetros :id y paso de payloads 'extra' para transiciones fluidas.", body_style)],
        [Paragraph("<b>flutter_dotenv</b>", bold_style), Paragraph("6.0.1", body_style), Paragraph("Carga desacoplada de variables de entorno (.env) como API_BASE_URL y APP_NAME, con respaldo automático en caso de falta de archivo.", body_style)],
    ]
    t_pkg = Table(pkg_data, colWidths=[90, 60, 380])
    t_pkg.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), primary_color),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, bg_light]),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_pkg)
    
    elements.append(PageBreak())
    
    # Arquitectura y Estructura
    elements.append(Paragraph("4. Arquitectura y Estructura de Carpetas", h1_style))
    elements.append(Paragraph(
        "Se organizó el código siguiendo la arquitectura estricta solicitada en el taller:",
        body_style
    ))
    
    arch_data = [
        [Paragraph("<b>Capa / Directorio</b>", bold_style), Paragraph("<b>Archivos Clave</b>", bold_style), Paragraph("<b>Responsabilidad</b>", bold_style)],
        [Paragraph("<b>lib/config/</b>", code_style), Paragraph("app_config.dart<br/>constants.dart", code_style), Paragraph("Gestión de variables (.env), constantes de endpoints y definición de nombres de rutas.", body_style)],
        [Paragraph("<b>lib/models/</b>", code_style), Paragraph("department_model.dart<br/>president_model.dart<br/>touristic_attraction_model.dart<br/>typical_dish_model.dart", code_style), Paragraph("Modelos con tipado estricto, serialización <i>fromJson()</i>, deserialización <i>toJson()</i> y getters utilitarios.", body_style)],
        [Paragraph("<b>lib/services/</b>", code_style), Paragraph("api_service.dart", code_style), Paragraph("Capa HTTP con <i>http.Client</i>, timeouts, <i>ApiException</i> personalizada y mapeo de excepciones de red.", body_style)],
        [Paragraph("<b>lib/routes/</b>", code_style), Paragraph("app_router.dart", code_style), Paragraph("Configuración centralizada de <i>GoRouter</i>, rutas hijas, parámetros de ruta y pantalla 404.", body_style)],
        [Paragraph("<b>lib/themes/</b>", code_style), Paragraph("app_theme.dart", code_style), Paragraph("Tema Material 3 con paleta institucional colombiana, estilización de Cards y Badges.", body_style)],
        [Paragraph("<b>lib/views/</b>", code_style), Paragraph("dashboard_view.dart<br/>..._list_view.dart<br/>..._detail_view.dart", code_style), Paragraph("Pantallas principales: Dashboard introductorio, Listados con ListView.builder y Detalles completos.", body_style)],
        [Paragraph("<b>lib/widgets/</b>", code_style), Paragraph("loading_widget.dart<br/>error_view_widget.dart<br/>search_bar_widget.dart<br/>stat_badge_widget.dart<br/>network_image_with_fallback.dart", code_style), Paragraph("Componentes reutilizables desacoplados para renderizado de estados, imágenes e indicadores.", body_style)],
    ]
    t_arch = Table(arch_data, colWidths=[100, 160, 270])
    t_arch.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), primary_color),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, bg_light]),
        ('PADDING', (0,0), (-1,-1), 5),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
    ]))
    elements.append(t_arch)
    elements.append(Spacer(1, 10))
    
    # Rutas go_router
    elements.append(Paragraph("5. Navegación Declarativa con go_router (Maestro-Detalle)", h1_style))
    route_data = [
        [Paragraph("<b>Ruta ('name')</b>", bold_style), Paragraph("<b>Path</b>", bold_style), Paragraph("<b>Parámetros Enviados</b>", bold_style), Paragraph("<b>Pantalla Destino</b>", bold_style)],
        [Paragraph("dashboard", code_style), Paragraph("/", code_style), Paragraph("Ninguno", body_style), Paragraph("DashboardView", body_style)],
        [Paragraph("departments", code_style), Paragraph("/departments", code_style), Paragraph("Ninguno", body_style), Paragraph("DepartmentsListView", body_style)],
        [Paragraph("department-detail", code_style), Paragraph("/departments/:id", code_style), Paragraph(":id (int) + DepartmentModel (extra)", body_style), Paragraph("DepartmentDetailView", body_style)],
        [Paragraph("presidents", code_style), Paragraph("/presidents", code_style), Paragraph("Ninguno", body_style), Paragraph("PresidentsListView", body_style)],
        [Paragraph("president-detail", code_style), Paragraph("/presidents/:id", code_style), Paragraph(":id (int) + PresidentModel (extra)", body_style), Paragraph("PresidentDetailView", body_style)],
        [Paragraph("attractions", code_style), Paragraph("/attractions", code_style), Paragraph("Ninguno", body_style), Paragraph("AttractionsListView", body_style)],
        [Paragraph("attraction-detail", code_style), Paragraph("/attractions/:id", code_style), Paragraph(":id (int) + TouristicAttractionModel (extra)", body_style), Paragraph("AttractionDetailView", body_style)],
        [Paragraph("dishes", code_style), Paragraph("/dishes", code_style), Paragraph("Ninguno", body_style), Paragraph("DishesListView", body_style)],
        [Paragraph("dish-detail", code_style), Paragraph("/dishes/:id", code_style), Paragraph(":id (int) + TypicalDishModel (extra)", body_style), Paragraph("DishDetailView", body_style)],
    ]
    t_route = Table(route_data, colWidths=[105, 115, 170, 140])
    t_route.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), primary_color),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, bg_light]),
        ('PADDING', (0,0), (-1,-1), 4),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
    ]))
    elements.append(t_route)
    elements.append(Spacer(1, 10))
    
    # Manejo de Estados
    elements.append(Paragraph("6. Manejo de Estados (Cargando / Éxito / Error)", h1_style))
    elements.append(Paragraph(
        "• <b>Estado de Carga:</b> Indicador de progreso circular personalizado con mensajes descriptivos acordes a cada pantalla.<br/>"
        "• <b>Estado de Éxito:</b> Renderizado de listas dinámicas con <i>ListView.builder</i>, tarjetas interactivas, barra de búsqueda en vivo y pull-to-refresh.<br/>"
        "• <b>Estado de Error:</b> Interceptor de errores que traduce <i>SocketException</i>, <i>TimeoutException</i> y status codes (404, 500) en mensajes legibles con botón de reintento directo.",
        body_style
    ))
    
    elements.append(PageBreak())
    
    # Evidencias Visuales
    elements.append(Paragraph("7. Evidencias Visuales de la Aplicación", h1_style))
    
    sc_dir = "docs/screenshots"
    img_w, img_h = 160, 320
    
    shot_pairs = [
        ("01_dashboard.png", "Dashboard Principal con Cards", "02_departments_list.png", "Listado con Buscador y Filtro"),
        ("03_department_detail.png", "Detalle de Departamento (Métricas)", "04_presidents_list.png", "Listado Histórico de Presidentes"),
        ("05_typical_dishes_list.png", "Gastronomía y Platos Típicos", "06_states_handling.png", "Manejo de Estados (Carga y Error)"),
    ]
    
    for fn1, cap1, fn2, cap2 in shot_pairs:
        p1 = os.path.join(sc_dir, fn1)
        p2 = os.path.join(sc_dir, fn2)
        
        cells = []
        if os.path.exists(p1):
            i1 = ReportLabImage(p1, width=img_w, height=img_h)
            cells.append([i1, Paragraph(f"<b>{cap1}</b>", ParagraphStyle('C', parent=body_style, alignment=1, fontSize=8))])
        else:
            cells.append([Paragraph(cap1, body_style)])
            
        if os.path.exists(p2):
            i2 = ReportLabImage(p2, width=img_w, height=img_h)
            cells.append([i2, Paragraph(f"<b>{cap2}</b>", ParagraphStyle('C', parent=body_style, alignment=1, fontSize=8))])
        else:
            cells.append([Paragraph(cap2, body_style)])
            
        grid_data = [
            [cells[0][0], cells[1][0]],
            [cells[0][1], cells[1][1]],
        ]
        t_shots = Table(grid_data, colWidths=[265, 265])
        t_shots.setStyle(TableStyle([
            ('ALIGN', (0,0), (-1,-1), 'CENTER'),
            ('VALIGN', (0,0), (-1,-1), 'TOP'),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ]))
        elements.append(t_shots)
        elements.append(Spacer(1, 10))
        
        if fn1 != shot_pairs[-1][0]:
            elements.append(PageBreak())
            
    # Flujo GitFlow y Calidad de Código
    elements.append(Paragraph("8. Flujo GitFlow y Pruebas Automatizadas", h1_style))
    elements.append(Paragraph(
        "• <b>Flujo de Trabajo GitFlow:</b> Repositorio público con ramas <b>main</b> (estable), <b>dev</b> (integración) y "
        "<b>feature/taller_api_colombia</b> donde se registraron commits atómicos y semánticos (<i>feat:</i>, <i>chore:</i>, <i>refactor:</i>, <i>test:</i>, <i>docs:</i>).<br/>"
        "• <b>Pull Request:</b> Integración desde <i>feature/taller_api_colombia</i> hacia <i>dev</i> y merge final a <i>main</i>.<br/>"
        "• <b>Análisis Estático (flutter analyze):</b> 0 errores, 0 advertencias, 0 problemas de linter.<br/>"
        "• <b>Pruebas Automatizadas (flutter test):</b> 10 pruebas unitarias y de widgets ejecutadas con 100% de éxito en models, api_service y widget tree.",
        body_style
    ))
    
    doc.build(elements)
    print(f"PDF generated successfully at: {pdf_path}")

if __name__ == "__main__":
    out1 = "Informe_Taller_Datos_Abiertos_Brahian_Tenorio.pdf"
    out2 = os.path.join("..", "Informe_Taller_Datos_Abiertos_Brahian_Tenorio.pdf")
    create_report(out1)
    try:
        create_report(out2)
    except:
        pass
