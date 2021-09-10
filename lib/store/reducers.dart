import 'package:advantage_club/model/advantage.dart';
import 'package:advantage_club/model/banner.dart';
import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/model/checkable_object.dart';
import 'package:advantage_club/model/user.dart';
import 'actions.dart';
import 'app_state.dart';

AppState appStateReducer(AppState state, action) {
  return AppState(
      currentSearchContent: serachReducer(state, action),
      currentCategory: categoryReducer(state, action),
      checkboxes: checkBoxesReducer(state, action),
      categories: categoriesReducer(state, action),
      banners: bannersReducer(state, action),
      advantagePagination: advantagesReducer(state, action),
      currentUser: userReducer(state, action));
}

Category categoryReducer(AppState state, action) {
  if (action is CategorySelected) {
    return action.category;
  }
  return state.currentCategory;
}

String serachReducer(AppState state, action) {
  if (action is Search) {
    return action.content;
  }
  return state.currentSearchContent;
}

User userReducer(AppState state, action){
  if(action is UserLogged){
    print("USER");
    return action.user;
  }
  return state.currentUser;
}

List<CheckableObject> checkBoxesReducer(AppState state, action) {
  if (action is CheckSelected) {
    if (state.checkboxes.map((e) => e.code).contains(action.check.code)) {
      return List.unmodifiable([]..addAll(state.checkboxes
          .where((element) => element.code != action.check.code)));
    }
    return List.unmodifiable([]
      ..addAll(state.checkboxes)
      ..add(action.check));
  }
  if (action is CategorySelected) {
    return List.unmodifiable(
        state.checkboxes.where((e) => e.type != CheckType.SUBCATEGORY));
  }
  if (action is ClearFilters) {
    return List.unmodifiable([]);
  }
  return state.checkboxes;
}

List<Category> categoriesReducer(AppState state, action) {
  if (action is LoadCategories) {
    return List.unmodifiable(action.categories);
  }
  return state.categories;
}

List<WingooBanner> bannersReducer(AppState state, action) {
  if (action is LoadBanners) {
    return List.unmodifiable(action.banners);
  }
  return state.banners;
}

AdvantagePagination advantagesReducer(AppState state, action) {
  if (action is LoadAdvantages) {
    final adivatanges = List<Advantage>.unmodifiable([]
      ..addAll(state.advantagePagination.advantages)
      ..addAll(action.advantages));
    return AdvantagePagination(
        adivatanges, action.lastPage, action.nextPage, action.notFound);
  }
  if (action is ClearAdvantages) {
    return AdvantagePagination(List.unmodifiable([]), false, 1, false);
  }
  return state.advantagePagination;
}
