import 'dart:convert';
import 'package:advantage_club/model/category.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class CategoryService {

  Future<List<Category>> categories() async {
    var url = "${Config.api}/advantages/categories?menuCategory=true";
    var response = await http.get(url);
    final parsed = json.decode(response.body);
    var result = parsed['items'].map<Category>((json) => Category.fromJson(json)).toList();
    return result;
  }
  
}