/// Model representing a Colombian Typical Dish.
class TypicalDishModel {
  final int id;
  final String name;
  final String description;
  final String ingredients;
  final String? imageUrl;
  final int? departmentId;
  final String? departmentName;

  TypicalDishModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    this.imageUrl,
    this.departmentId,
    this.departmentName,
  });

  factory TypicalDishModel.fromJson(Map<String, dynamic> json) {
    String? departmentName;
    if (json['department'] is Map<String, dynamic>) {
      departmentName = json['department']['name'] as String?;
    }

    return TypicalDishModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? 'Sin descripción disponible.',
      ingredients: json['ingredients'] as String? ?? 'No especificados.',
      imageUrl: json['imageUrl'] as String?,
      departmentId: json['departmentId'] as int?,
      departmentName: departmentName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'departmentId': departmentId,
      'departmentName': departmentName,
    };
  }

  List<String> get ingredientsList {
    return ingredients
        .split(RegExp(r'[,.]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
