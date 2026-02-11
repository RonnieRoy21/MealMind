class Meals {
  int? id;
  String? mealName;
  String? mealPrice;
  String? mealImage;
  String? mealDescription;

  Meals(
      {this.id,
      this.mealName,
      this.mealPrice,
      this.mealImage,
      this.mealDescription});

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      id: json['food_id'] as int?,
      mealName: json['food_name'] as String?,
      mealPrice: json['food_price']?.toString(),
      mealImage: json['food_image'] as String?,
      mealDescription: json['food_description'] as String?,
    );
  }
}
