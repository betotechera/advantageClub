import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/service/category_service.dart';
import 'package:advantage_club/store/actions.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:redux/redux.dart';

class CategoryView {
  final List<Category> categories;
  final Function loadCategories;

  CategoryView(this.categories, this.loadCategories);

  factory CategoryView.create(Store<AppState> store) {
    _loadCategories() async {
      if (store.state.categories.isEmpty) {
        final categories = await CategoryService().categories();
        store.dispatch(LoadCategories(categories));
      }
    }

    return CategoryView(store.state.categories, _loadCategories);
  }
}