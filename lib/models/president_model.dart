/// Model representing a Colombian President.
class PresidentModel {
  final int id;
  final String name;
  final String lastName;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  final String description;
  final String? image;
  final int? cityId;

  PresidentModel({
    required this.id,
    required this.name,
    required this.lastName,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    required this.description,
    this.image,
    this.cityId,
  });

  factory PresidentModel.fromJson(Map<String, dynamic> json) {
    return PresidentModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      startPeriodDate: json['startPeriodDate'] as String?,
      endPeriodDate: json['endPeriodDate'] as String?,
      politicalParty: json['politicalParty'] as String? ?? 'No especificado',
      description: json['description'] as String? ?? 'Sin biografía disponible.',
      image: json['image'] as String?,
      cityId: json['cityId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'startPeriodDate': startPeriodDate,
      'endPeriodDate': endPeriodDate,
      'politicalParty': politicalParty,
      'description': description,
      'image': image,
      'cityId': cityId,
    };
  }

  String get fullName => '$name $lastName'.trim();

  String get periodFormatted {
    final start = startPeriodDate ?? 'Inicio desconocido';
    final end = endPeriodDate ?? 'Actualidad';
    return '$start  —  $end';
  }
}
