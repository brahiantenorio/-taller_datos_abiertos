/// Model representing a Colombian Department and its capital city.
class DepartmentModel {
  final int id;
  final String name;
  final String description;
  final int? cityCapitalId;
  final int? municipalities;
  final num? surface;
  final int? population;
  final String? phonePrefix;
  final CityCapitalModel? cityCapital;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.description,
    this.cityCapitalId,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
    this.cityCapital,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? 'Sin descripción disponible.',
      cityCapitalId: json['cityCapitalId'] as int?,
      municipalities: json['municipalities'] as int?,
      surface: json['surface'] as num?,
      population: json['population'] as int?,
      phonePrefix: json['phonePrefix']?.toString(),
      cityCapital: json['cityCapital'] != null
          ? CityCapitalModel.fromJson(json['cityCapital'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cityCapitalId': cityCapitalId,
      'municipalities': municipalities,
      'surface': surface,
      'population': population,
      'phonePrefix': phonePrefix,
      'cityCapital': cityCapital?.toJson(),
    };
  }

  String get capitalName => cityCapital?.name ?? 'No especificada';
}

/// Model representing the capital city of a department.
class CityCapitalModel {
  final int id;
  final String name;
  final String description;
  final num? surface;
  final int? population;
  final String? postalCode;

  CityCapitalModel({
    required this.id,
    required this.name,
    required this.description,
    this.surface,
    this.population,
    this.postalCode,
  });

  factory CityCapitalModel.fromJson(Map<String, dynamic> json) {
    return CityCapitalModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? '',
      surface: json['surface'] as num?,
      population: json['population'] as int?,
      postalCode: json['postalCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'surface': surface,
      'population': population,
      'postalCode': postalCode,
    };
  }
}
