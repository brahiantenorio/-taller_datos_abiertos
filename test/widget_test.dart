import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/main.dart';

void main() {
  testWidgets('Dashboard renders main title and modules', (WidgetTester tester) async {
    await tester.pumpWidget(const ColombiaDatosAbiertosApp());
    await tester.pumpAndSettle();

    expect(find.text('Módulos de Información'), findsOneWidget);
    expect(find.text('Departamentos'), findsOneWidget);
    expect(find.text('Presidentes'), findsOneWidget);
    expect(find.text('Atracciones Turísticas'), findsOneWidget);
    expect(find.text('Platos Típicos'), findsOneWidget);
  });
}
