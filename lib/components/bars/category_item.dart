import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/store/actions.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CategoryItemWidget extends StatefulWidget {
  final Category category;
  Function onTap;
  CategoryItemWidget({required this.category, required this.onTap});

  @override
  _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {

  bool _matchMyCategory(Category category) {
    return category != null && category.id == widget.category.id;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CategoryView>(
      converter: (store) {
        return _CategoryView.create(store, widget.category);
      },
      builder: (context, categoryView) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            child: InkWell(
                onTap: () {
                  categoryView.categorySelected();
                  if (widget.onTap != null) {
                    widget.onTap();
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: (_matchMyCategory(categoryView.category)
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColorDark),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: _matchMyCategory(categoryView.category)
                                ? Theme.of(context).primaryColorDark
                                : Theme.of(context).primaryColorLight)),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(widget.category.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: _matchMyCategory(categoryView.category)
                                    ? Theme.of(context).primaryColorDark
                                    : Theme.of(context).primaryColorLight))))));
      },
    );
  }
}

class _CategoryView {
  final Category category;
  final Function categorySelected;

  _CategoryView(this.category, this.categorySelected);

  factory _CategoryView.create(Store<AppState> store, Category category) {
    _categorySelected() {
      if (store.state.currentCategory != category) {
        store.dispatch(CategorySelected(category));
        return;
      }
      store.dispatch(ClearFilters());
    }

    return _CategoryView(store.state.currentCategory, _categorySelected);
  }
}
