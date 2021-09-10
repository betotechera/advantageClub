
import 'package:advantage_club/model/checkable_object.dart';
import 'package:advantage_club/store/actions.dart';

class Subcategory implements CheckableObject {
  final String slugName;
  final String name;
  final num exhibitionPosition;
  final String icon;

  const Subcategory(
      this.name, this.exhibitionPosition, this.icon, this.slugName);

  Subcategory.fromJson(Map<String, dynamic> json)
      : slugName = json['slugName'],
        icon = json['icon'],
        name = json['name'],
        exhibitionPosition = json['exhibitionPosition'];

  String get text => this.name;

  @override
  String get code => this.slugName;

  @override
  CheckType get type => CheckType.SUBCATEGORY;
}
