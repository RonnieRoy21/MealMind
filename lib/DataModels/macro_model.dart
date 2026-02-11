class MacroModel {

  final int calories;
  final int carbohydrates;
  final int protein;
  final int sodium;
  final int sugar;
  final int fiber;
  final int cholesterol;
  final int potassium;
  final int fats;

  MacroModel({
    required this.calories,
    required this.carbohydrates,
    required this.protein,
    required this.sodium,
    required this.sugar,
    required this.fiber,
    required this.cholesterol,
    required this.potassium,
    required this.fats,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'fat': fats,
      'sodium': sodium,
      'sugar': sugar,
      'fiber': fiber,
      'cholesterol': cholesterol,
      'potassium': potassium,

    };
  }

  factory MacroModel.fromJson(Map<String, dynamic> json) {
    return MacroModel(
      calories: json['calories'] as int,
      carbohydrates: json['carbs'] as int,
      protein: json['protein'] as int,
      fats: json['fat'] as int,
      sodium: json['sodium'] as int,
      sugar: json['sugar'] as int,
      fiber: json['fiber'] as int,
      cholesterol: json['cholesterol'] as int,
      potassium: json['potassium'] as int,
    );
  }
}
