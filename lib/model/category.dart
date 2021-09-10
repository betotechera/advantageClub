
import 'package:advantage_club/model/subcategory.dart';

class Category {
  final String id;
  final String name;
  final String slugName;
  final num exhibitionPosition;
  final String icon;
  final List<Subcategory> subcategories;

  const Category(this.id, this.name, this.exhibitionPosition, this.icon,
      this.subcategories, this.slugName);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        exhibitionPosition = json['exhibitionPosition'],
        slugName = json['slugName'],
        icon = json['icon'],
        subcategories = json['subcategories']
            .map<Subcategory>((sub) => Subcategory.fromJson(sub))
            .toList();
}
