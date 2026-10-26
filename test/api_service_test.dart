import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:taller_datos_abiertos/services/api_service.dart';

void main() {
  group('ApiService', () {
    test('getDepartments returns parsed list on 200 response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/Department')) {
          final body = json.encode([
            {
              'id': 1,
              'name': 'Antioquia',
              'description': 'Región andina',
              'cityCapital': {'id': 12, 'name': 'Medellín', 'description': ''},
            },
            {
              'id': 21,
              'name': 'Meta',
              'description': 'Región orinoquía',
              'cityCapital': {'id': 740, 'name': 'Villavicencio', 'description': ''},
            }
          ]);
          return http.Response(body, 200, headers: {'content-type': 'application/json'});
        }
        return http.Response('Not Found', 404);
      });

      final service = ApiService(client: mockClient);
      final departments = await service.getDepartments();

      expect(departments.length, 2);
      expect(departments[0].name, 'Antioquia');
      expect(departments[0].capitalName, 'Medellín');
      expect(departments[1].name, 'Meta');
    });

    test('getDepartmentById returns single item on 200 response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/Department/21')) {
          final body = json.encode({
            'id': 21,
            'name': 'Meta',
            'description': 'Detalle del Meta',
            'cityCapital': {'id': 740, 'name': 'Villavicencio', 'description': ''},
          });
          return http.Response(body, 200, headers: {'content-type': 'application/json'});
        }
        return http.Response('Not Found', 404);
      });

      final service = ApiService(client: mockClient);
      final dept = await service.getDepartmentById(21);

      expect(dept.id, 21);
      expect(dept.name, 'Meta');
      expect(dept.capitalName, 'Villavicencio');
    });

    test('throws ApiException on 404 response', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = ApiService(client: mockClient);

      expect(
        () async => await service.getDepartmentById(999),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws ApiException on 500 server error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = ApiService(client: mockClient);

      expect(
        () async => await service.getPresidents(),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
