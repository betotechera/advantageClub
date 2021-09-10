
import 'package:advantage_club/model/advantage.dart';
import 'package:advantage_club/model/banner.dart';
import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/model/checkable_object.dart';
import 'package:advantage_club/model/user.dart';

class CategorySelected {
  final Category category;
  CategorySelected(this.category);
}

class Search {
  final String content;
  Search(this.content);
}

class CheckSelected {
  final CheckableObject check;
  CheckSelected(this.check);
}

class ClearFilters {}

class LoadCategories {
  final List<Category> categories;
  
  LoadCategories(this.categories);
}

class LoadBanners {
  final List<WingooBanner> banners;
  
  LoadBanners(this.banners);
}

class LoadAdvantages {
  final List<Advantage> advantages;
  final int nextPage;
  final bool lastPage;
  final bool notFound;
  
  LoadAdvantages(this.advantages, this.nextPage, this.lastPage, this.notFound);
}

class ClearAdvantages {}

class UserLogged {
  final User user;

  UserLogged(this.user);
}

enum CheckType {
  ADVANTAGE_TYPE,
  SUBCATEGORY
}