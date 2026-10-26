# Pull Request: Integración de Taller Datos Abiertos de Colombia

## 📌 Descripción General
Este Pull Request integra el desarrollo completo del **Taller 2do Corte: Datos Abiertos de Colombia** para la materia **Móviles con Flutter (Electiva Profesional I)**.

## 🎯 Endpoints Consumidos (API Colombia)
1. **Departamentos:** `GET /Department` y `GET /Department/{id}`
2. **Presidentes:** `GET /President` y `GET /President/{id}`
3. **Atracciones Turísticas:** `GET /TouristicAttraction` y `GET /TouristicAttraction/{id}`
4. **Platos Típicos:** `GET /TypicalDish` y `GET /TypicalDish/{id}`

## 📦 Paquetes Implementados
- `http: ^1.6.0` (Consumo HTTP, manejo de estados y status codes)
- `go_router: ^18.1.1` (Navegación declarativa con rutas nombradas, parámetros `:id` y objetos `extra`)
- `flutter_dotenv: ^6.0.1` (Configuración de variables de entorno `.env`)

## 🏗️ Arquitectura por Capas
- `lib/config/`: Carga segura de variables de entorno y constantes de rutas y endpoints.
- `lib/models/`: Modelos tipados con `fromJson`, `toJson` y métodos utilitarios.
- `lib/services/`: Capa HTTP con `ApiService`, control de status codes, timeouts y `ApiException`.
- `lib/routes/`: Enrutamiento declarativo con `GoRouter` y pantalla 404 personalizada.
- `lib/themes/`: Tema visual Material 3 con colores institucionales colombianos.
- `lib/views/`: Dashboard, Listados con `ListView.builder` y búsqueda interactiva, y pantallas de Detalle.
- `lib/widgets/`: Componentes reutilizables (`LoadingWidget`, `ErrorViewWidget`, `SearchBarWidget`, `StatBadgeWidget`, `NetworkImageWithFallback`, `EmptyStateWidget`).

## 🧪 Pruebas y Validación de Calidad
- [x] **`flutter analyze`:** 0 errores, 0 warnings (100% clean).
- [x] **`flutter test`:** 10 pruebas unitarias y de widgets ejecutadas con éxito.
- [x] **`flutter build web`:** Compilación exitosa para release.

## 📸 Evidencias Visuales
- Capturas de pantalla integradas en `docs/screenshots/` y documentadas en `README.md`.
- Informe técnico generado en formato PDF: `Informe_Taller_Datos_Abiertos_Brahian_Tenorio.pdf`.
