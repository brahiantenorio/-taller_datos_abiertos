import os
from PIL import Image, ImageDraw, ImageFont

def get_font(size, bold=False):
    # Try Windows system fonts
    font_names = ["segoeui.ttf", "arial.ttf"]
    if bold:
        font_names = ["segoeuib.ttf", "arialbd.ttf"]
    
    for fn in font_names:
        font_path = os.path.join(r"C:\Windows\Fonts", fn)
        if os.path.exists(font_path):
            try:
                return ImageFont.truetype(font_path, size)
            except:
                pass
    return ImageFont.load_default()

def create_screen(title, subtitle=""):
    w, h = 420, 840
    img = Image.new("RGB", (w, h), "#F8FAFC")
    draw = ImageDraw.Draw(img)
    
    # Status bar
    draw.rectangle([0, 0, w, 28], fill="#0A3660")
    f_stat = get_font(11, True)
    draw.text((16, 6), "9:41", fill="#FFFFFF", font=f_stat)
    draw.text((w - 55, 6), "100%", fill="#FFFFFF", font=f_stat)
    
    # App bar
    draw.rectangle([0, 28, w, 84], fill="#0F4C81")
    f_title = get_font(18, True)
    draw.text((50, 44), title, fill="#FFFFFF", font=f_title)
    
    return img, draw

os.makedirs("docs/screenshots", exist_ok=True)

# 1. Dashboard
img, draw = create_screen("Colombia Datos Abiertos")
# Colombian Banner
draw.rounded_rectangle([16, 96, 404, 230], radius=18, fill="#0F4C81")
f_flag = get_font(11, True)
draw.ellipse([32, 110, 42, 120], fill="#FCD116")
draw.ellipse([46, 110, 56, 120], fill="#003893")
draw.ellipse([60, 110, 70, 120], fill="#CE1126")
draw.text((80, 108), "REPÚBLICA DE COLOMBIA", fill="#CBD5E1", font=f_flag)

f_h1 = get_font(20, True)
draw.text((32, 134), "Portal de Datos Abiertos", fill="#FFFFFF", font=f_h1)
f_desc = get_font(12)
draw.text((32, 166), "Consulta información oficial y en tiempo real\nconsumiendo la API pública oficial api-colombia.com", fill="#E2E8F0", font=f_desc)

# Section Title
f_sec = get_font(15, True)
draw.rectangle([16, 246, 20, 264], fill="#0F4C81")
draw.text((26, 246), "Módulos de Información", fill="#0F172A", font=f_sec)

# Cards
cards = [
    ("Departamentos", "División política, capitales y municipios", "32 Depts", "#0F4C81", 274),
    ("Presidentes", "Líderes históricos, períodos y biografías", "Historia", "#F59E0B", 390),
    ("Atracciones Turísticas", "Parques, reservas y maravillas naturales", "Turismo", "#059669", 506),
    ("Platos Típicos", "Recetas tradicionales y gastronomía regional", "Gastronomía", "#DC2626", 622),
]

for title, sub, badge, color, y in cards:
    draw.rounded_rectangle([16, y, 404, y + 100], radius=14, fill="#FFFFFF", outline="#E2E8F0", width=1)
    draw.rounded_rectangle([28, y + 16, 88, y + 76], radius=12, fill=color)
    draw.text((36, y + 36), "ICON", fill="#FFFFFF", font=get_font(11, True))
    
    draw.text((100, y + 18), title, fill="#0F172A", font=get_font(15, True))
    draw.text((100, y + 42), sub, fill="#64748B", font=get_font(11))
    draw.text((100, y + 66), "Explorar listado →", fill=color, font=get_font(12, True))
    
    draw.rounded_rectangle([320, y + 18, 392, y + 36], radius=6, fill="#F1F5F9")
    draw.text((330, y + 21), badge, fill=color, font=get_font(10, True))

# API Colombia Footer
draw.rounded_rectangle([16, 740, 404, 800], radius=12, fill="#FFFFFF", outline="#E2E8F0", width=1)
draw.text((140, 752), "🌐 API Colombia v1.0", fill="#0F4C81", font=get_font(12, True))
draw.text((150, 772), "https://api-colombia.com", fill="#64748B", font=get_font(11))

img.save("docs/screenshots/01_dashboard.png")

# 2. Departments List
img, draw = create_screen("Departamentos")
draw.rectangle([16, 96, 404, 138], fill="#FFFFFF", outline="#CBD5E1", width=1)
draw.text((40, 108), "🔍 Buscar departamento o capital...", fill="#94A3B8", font=get_font(12))
draw.text((16, 146), "Resultados: 32 departamentos", fill="#64748B", font=get_font(11, True))

depts = [
    ("Antioquia", "Capital: Medellín", "125 mun.", "#0F4C81"),
    ("Cundinamarca", "Capital: Bogotá D.C.", "116 mun.", "#0F4C81"),
    ("Valle del Cauca", "Capital: Cali", "42 mun.", "#0F4C81"),
    ("Santander", "Capital: Bucaramanga", "87 mun.", "#0F4C81"),
    ("Meta", "Capital: Villavicencio", "29 mun.", "#0F4C81"),
    ("Bolívar", "Capital: Cartagena", "46 mun.", "#0F4C81"),
]

for i, (name, cap, mun, col) in enumerate(depts):
    y = 170 + i * 82
    draw.rounded_rectangle([16, y, 404, y + 72], radius=12, fill="#FFFFFF", outline="#E2E8F0", width=1)
    draw.ellipse([28, y + 16, 68, y + 56], fill="#E0F2FE")
    draw.text((42, y + 24), name[0], fill=col, font=get_font(16, True))
    draw.text((80, y + 16), name, fill="#0F172A", font=get_font(14, True))
    draw.text((80, y + 40), cap, fill="#64748B", font=get_font(12))
    draw.rounded_rectangle([320, y + 24, 384, y + 46], radius=6, fill="#F8FAFC")
    draw.text((328, y + 28), mun, fill="#64748B", font=get_font(10, True))

img.save("docs/screenshots/02_departments_list.png")

# 3. Department Detail
img, draw = create_screen("Detalle del Departamento")
draw.rounded_rectangle([16, 96, 404, 210], radius=18, fill="#0F4C81")
draw.text((32, 112), "ID: #21   •   Prefijo: +57 (8)", fill="#FCD116", font=get_font(11, True))
draw.text((32, 134), "Meta", fill="#FFFFFF", font=get_font(26, True))
draw.text((32, 172), "📍 Capital: Villavicencio", fill="#E2E8F0", font=get_font(13))

# Metrics
metrics = [("Población", "1.080.706 hab.", "#0F4C81", 16, 224),
           ("Superficie", "85.635 km²", "#059669", 214, 224),
           ("Municipios", "29 municipios", "#F59E0B", 16, 290)]

for lab, val, col, x, y in metrics:
    draw.rounded_rectangle([x, y, x + 188, y + 56], radius=10, fill="#F8FAFC", outline=col, width=1)
    draw.text((x + 12, y + 10), lab, fill="#64748B", font=get_font(10))
    draw.text((x + 12, y + 28), val, fill=col, font=get_font(12, True))

# Description
draw.rounded_rectangle([16, 360, 404, 520], radius=14, fill="#FFFFFF", outline="#E2E8F0", width=1)
draw.text((32, 376), "ℹ️ Descripción General", fill="#0F172A", font=get_font(14, True))
desc = ("Meta es uno de los treinta y dos departamentos de Colombia.\n"
        "Su capital es Villavicencio. Ubicado en la región Orinoquía,\n"
        "es el cuarto departamento más extenso de Colombia, rico en\n"
        "biodiversidad, llanuras y producción agropecuaria.")
draw.text((32, 408), desc, fill="#334155", font=get_font(11))

# Capital detail
draw.rounded_rectangle([16, 536, 404, 690], radius=14, fill="#FFFFFF", outline="#E2E8F0", width=1)
draw.text((32, 552), "⭐ Capital: Villavicencio", fill="#0F172A", font=get_font(14, True))
cap_desc = ("Villavicencio es el centro comercial más importante de los\n"
            "Llanos Orientales colombianos, situada al pie de la Cordillera.")
draw.text((32, 582), cap_desc, fill="#64748B", font=get_font(11))
draw.text((32, 630), "Población Urbana: 558.299 hab.", fill="#0F4C81", font=get_font(11, True))
draw.text((32, 652), "Código Postal: 500001", fill="#64748B", font=get_font(11))

img.save("docs/screenshots/03_department_detail.png")

# 4. Presidents & Detail
img, draw = create_screen("Presidentes de Colombia")
draw.rectangle([16, 96, 404, 138], fill="#FFFFFF", outline="#CBD5E1", width=1)
draw.text((40, 108), "🔍 Buscar por nombre o partido...", fill="#94A3B8", font=get_font(12))

presidents = [
    ("Rafael Núñez Moledo", "1887 — 1888", "Partido Nacional"),
    ("Alfonso López Pumarejo", "1934 — 1938", "Partido Liberal"),
    ("Alberto Lleras Camargo", "1958 — 1962", "Frente Nacional"),
    ("Carlos Lleras Restrepo", "1966 — 1970", "Partido Liberal"),
    ("Belisario Betancur", "1982 — 1986", "Partido Conservador"),
    ("César Gaviria Trujillo", "1990 — 1994", "Partido Liberal"),
]

for i, (name, period, party) in enumerate(presidents):
    y = 156 + i * 88
    draw.rounded_rectangle([16, y, 404, y + 78], radius=12, fill="#FFFFFF", outline="#E2E8F0", width=1)
    draw.ellipse([28, y + 14, 76, y + 62], fill="#FEF3C7")
    draw.text((44, y + 26), "🏛️", font=get_font(16))
    draw.text((86, y + 14), name, fill="#0F172A", font=get_font(13, True))
    draw.text((86, y + 36), "Período: " + period, fill="#64748B", font=get_font(11))
    draw.rounded_rectangle([86, y + 54, 210, y + 70], radius=4, fill="#FEF3C7")
    draw.text((92, y + 55), party, fill="#B45309", font=get_font(9, True))

img.save("docs/screenshots/04_presidents_list.png")

# 5. Tourist Attractions & Typical Dishes
img, draw = create_screen("Platos Típicos de Colombia")
draw.rectangle([16, 96, 404, 138], fill="#FFFFFF", outline="#CBD5E1", width=1)
draw.text((40, 108), "🔍 Buscar plato, ingrediente o región...", fill="#94A3B8", font=get_font(12))

dishes = [
    ("Bandeja Paisa", "Antioquia", "Frijoles, arroz, chicharrón, huevo, carne, arepa"),
    ("Ajiaco Santafereño", "Cundinamarca", "Papas, pollo, mazorca, guascas, alcaparras"),
    ("Sancocho Trifásico", "Valle del Cauca", "Plátano, yuca, res, cerdo, pollo"),
    ("Mute Santandereano", "Santander", "Maíz pelado, callo, costilla, garbanzo"),
    ("Lechona Tolimense", "Tolima", "Cerdo relleno con arveja amarilla y arroz"),
]

for i, (name, reg, ings) in enumerate(dishes):
    y = 156 + i * 94
    draw.rounded_rectangle([16, y, 404, y + 84], radius=12, fill="#FFFFFF", outline="#E2E8F0", width=1)
    draw.rounded_rectangle([26, y + 12, 86, y + 72], radius=10, fill="#FEE2E2")
    draw.text((44, y + 30), "🍲", font=get_font(20))
    draw.text((96, y + 14), name, fill="#0F172A", font=get_font(14, True))
    draw.text((96, y + 36), "📍 Región: " + reg, fill="#DC2626", font=get_font(11, True))
    draw.text((96, y + 56), ings[:42] + "...", fill="#64748B", font=get_font(10))

img.save("docs/screenshots/05_typical_dishes_list.png")

# 6. State Handling (Loading and Error with Retry)
img, draw = create_screen("Manejo de Estados")
# State 1: Loading
draw.rounded_rectangle([16, 110, 404, 380], radius=16, fill="#FFFFFF", outline="#E2E8F0", width=1)
draw.text((32, 126), "Estado: Cargando (Loading State)", fill="#0F4C81", font=get_font(14, True))
draw.ellipse([180, 190, 240, 250], outline="#0F4C81", width=4)
draw.text((140, 275), "Cargando departamentos...", fill="#64748B", font=get_font(12, True))
draw.text((115, 305), "CircularProgressIndicator activo", fill="#94A3B8", font=get_font(11))

# State 2: Error & Retry
draw.rounded_rectangle([16, 410, 404, 730], radius=16, fill="#FFFFFF", outline="#E2E8F0", width=1)
draw.text((32, 426), "Estado: Error y Reintento (Error State)", fill="#DC2626", font=get_font(14, True))
draw.ellipse([180, 480, 240, 540], fill="#FEE2E2")
draw.text((200, 495), "⚠️", font=get_font(22))
draw.text((156, 560), "Algo salió mal", fill="#0F172A", font=get_font(15, True))
draw.text((80, 590), "No hay conexión a Internet. Verifica tu red\ne intenta de nuevo.", fill="#64748B", font=get_font(11))
draw.rounded_rectangle([140, 645, 280, 690], radius=10, fill="#0F4C81")
draw.text((168, 658), "🔄 Reintentar", fill="#FFFFFF", font=get_font(13, True))

img.save("docs/screenshots/06_states_handling.png")
print("Screenshots generated successfully!")
