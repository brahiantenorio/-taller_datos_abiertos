/// Model representing a Touristic Attraction in Colombia.
class TouristicAttractionModel {
  final int id;
  final String name;
  final String description;
  final List<String> images;
  final String? latitude;
  final String? longitude;
  final int? cityId;
  final String? cityName;

  TouristicAttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    this.latitude,
    this.longitude,
    this.cityId,
    this.cityName,
  });

  factory TouristicAttractionModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedImages = [];
    if (json['images'] is List) {
      parsedImages = (json['images'] as List)
          .whereType<String>()
          .where((img) => img.isNotEmpty)
          .toList();
    }

    String? cityName;
    if (json['city'] is Map<String, dynamic>) {
      cityName = json['city']['name'] as String?;
    }

    return TouristicAttractionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? 'Sin descripción disponible.',
      images: parsedImages,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      cityId: json['cityId'] as int?,
      cityName: cityName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'cityId': cityId,
      'cityName': cityName,
    };
  }

  String? get primaryImage => images.isNotEmpty ? images.first : null;
}
