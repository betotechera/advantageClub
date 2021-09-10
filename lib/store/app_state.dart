import 'package:advantage_club/model/advantage.dart';
import 'package:advantage_club/model/banner.dart';
import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/model/checkable_object.dart';
import 'package:advantage_club/model/user.dart';

class AppState {
  String currentSearchContent;
  Category currentCategory;
  List<CheckableObject> checkboxes;
  List<Category> categories;
  List<WingooBanner> banners;
  AdvantagePagination advantagePagination;
  User currentUser;

  AppState(
      {required this.currentCategory,
      required this.checkboxes,
      required this.categories,
      required this.advantagePagination,
      required this.currentUser,
      required this.banners,
      required this.currentSearchContent});

  AppState.initalState()
      : currentSearchContent = ("_"),
        currentCategory = Category("_", "", 0, "_", [], "_"),
        currentUser = User("_", ""),
        checkboxes = List.unmodifiable([]),
        categories = List.unmodifiable([]),
        banners = List.unmodifiable([]),
        advantagePagination = AdvantagePagination.initalState();
}

class AdvantagePagination {
  final List<Advantage> advantages;
  final bool lastPage;
  final int nextPage;
  final bool notFound;

  AdvantagePagination(this.advantages, this.lastPage, this.nextPage, this.notFound);

  AdvantagePagination.initalState()
      : lastPage = false,
        nextPage = 1,
        notFound = false,
        advantages = List.unmodifiable([]);
  
}
