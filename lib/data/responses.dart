import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final String name;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@JsonSerializable()
class Dish {
  final int id;
  final String name;
  final double price;
  final int weight;
  final String description;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'tegs')
  final List<String>? tags;
  final int? quantity;

  Dish({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.quantity,
  });

  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);
}
