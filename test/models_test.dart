import 'package:flutter_test/flutter_test.dart';
import 'package:taller_datos_abiertos/models/department_model.dart';
import 'package:taller_datos_abiertos/models/president_model.dart';
import 'package:taller_datos_abiertos/models/touristic_attraction_model.dart';
import 'package:taller_datos_abiertos/models/typical_dish_model.dart';

void main() {
  group('DepartmentModel', () {
    test('fromJson and toJson parse attributes accurately', () {
      final json = {
        'id': 21,
        'name': 'Meta',
        'description': 'Departamento del Meta.',
        'cityCapitalId': 740,
        'municipalities': 29,
        'surface': 85635,
        'population': 1080706,
        'phonePrefix': '8',
        'cityCapital': {
          'id': 740,
          'name': 'Villavicencio',
          'description': 'Capital del Meta',
          'surface': 1338,
          'population': 558299,
          'postalCode': '500001',
        },
      };

      final model = DepartmentModel.fromJson(json);

      expect(model.id, 21);
      expect(model.name, 'Meta');
      expect(model.capitalName, 'Villavicencio');
      expect(model.municipalities, 29);
      expect(model.toJson()['name'], 'Meta');
    });

    test('handles null capital gracefully', () {
      final json = {
        'id': 1,
        'name': 'Antioquia',
        'description': 'Test',
      };

      final model = DepartmentModel.fromJson(json);
      expect(model.capitalName, 'No especificada');
    });
  });

  group('PresidentModel', () {
    test('fromJson and getters format full name and period', () {
      final json = {
        'id': 3,
        'name': 'Rafael',
        'lastName': 'Núñez',
        'startPeriodDate': '1887-06-04',
        'endPeriodDate': '1888-08-07',
        'politicalParty': 'Partido Nacional',
        'description': 'Presidente histórico de Colombia',
        'image': 'https://example.com/nunez.jpg',
      };

      final model = PresidentModel.fromJson(json);

      expect(model.fullName, 'Rafael Núñez');
      expect(model.periodFormatted, '1887-06-04  —  1888-08-07');
      expect(model.politicalParty, 'Partido Nacional');
      expect(model.toJson()['name'], 'Rafael');
    });
  });

  group('TouristicAttractionModel', () {
    test('fromJson extracts primaryImage and city name', () {
      final json = {
        'id': 36,
        'name': 'Hacienda Nápoles',
        'description': 'Parque temático',
        'images': [
          'https://example.com/img1.jpg',
          'https://example.com/img2.jpg',
        ],
        'latitude': '5.887894',
        'longitude': '-74.6418',
        'city': {
          'id': 88,
          'name': 'Puerto Triunfo',
        },
      };

      final model = TouristicAttractionModel.fromJson(json);

      expect(model.name, 'Hacienda Nápoles');
      expect(model.primaryImage, 'https://example.com/img1.jpg');
      expect(model.cityName, 'Puerto Triunfo');
      expect(model.images.length, 2);
    });
  });

  group('TypicalDishModel', () {
    test('fromJson parses ingredients and origin department', () {
      final json = {
        'id': 1,
        'name': 'Bandeja Paisa',
        'description': 'Plato tradicional de Colombia.',
        'ingredients': 'Frijoles, arroz, carne molida, chicharrón, huevo.',
        'imageUrl': 'https://example.com/bandeja.jpg',
        'department': {
          'id': 2,
          'name': 'Antioquia',
        },
      };

      final model = TypicalDishModel.fromJson(json);

      expect(model.name, 'Bandeja Paisa');
      expect(model.departmentName, 'Antioquia');
      expect(model.ingredientsList.length, 5);
      expect(model.ingredientsList.first, 'Frijoles');
    });
  });
}
