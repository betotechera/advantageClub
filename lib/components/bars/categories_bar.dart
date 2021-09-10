import 'package:advantage_club/components/generic/Text_icon_button.dart';
import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/model_views/advantage_view.dart';
import 'package:advantage_club/model_views/category_view.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'categories_bar_over.dart';
import 'category_item.dart';

class CategoriesMenu extends StatefulWidget {
  CategoriesMenu({required Key key}) : super(key: key);
  @override
  State createState() => CategoriesMenuState();
}

class CategoriesMenuState extends State<CategoriesMenu> {

  late OverlayEntry overlayEntry;

  OverlayEntry _createOverlayEntry() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    var offset = renderBox!.localToGlobal(Offset.zero);
    this.overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            left: 0,
            right: 0,
            top: offset.dy,
            child: CategoriesMenuOver(overlayEntry: overlayEntry)));
    Overlay.of(context)!.insert(this.overlayEntry);
    return this.overlayEntry;
  }

  @override
  void dispose() {
    super.dispose();
    try {
      overlayEntry.remove();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _showMenu = CrossFadeState.showFirst;
    return Material(
      child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 3, color: Theme.of(context).primaryColorLight)),
              color: Theme.of(context).primaryColorDark),
          child: StoreConnector<AppState, CategoryView>(
            builder: (BuildContext context, categoriesView) {
              if (categoriesView.categories.isNotEmpty) {
                _showMenu = CrossFadeState.showSecond;
              }
              return AnimatedCrossFade(
                crossFadeState: _showMenu,
                firstChild: _filterButton(),
                secondChild: StoreConnector<AppState, AdvantageView>(
                    converter: (Store<AppState> store) {
                  return AdvantageView.create(store);
                }, builder: (BuildContext context, advModel) {
                  return _menuItems(categoriesView.categories, advModel);
                }),
                duration: const Duration(seconds: 1),
              );
            },
            converter: (Store<AppState> store) {
              return CategoryView.create(store);
            },
            onInit: (store) => CategoryView.create(store).loadCategories(),
          )),
    );
  }

  Widget _menuItems(List<Category> categories, AdvantageView advantageView) {
    List<Widget> categoryList = [_filterButton()]..addAll(categories
        .map<Widget>((category) => CategoryItemWidget(
              category: category,
              onTap: () {
                advantageView.clearAdvList();
                advantageView.loadAdvantages();
              },
            ))
        .toList());
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return categoryList[index];
        },
      ),
    );
  }

  Widget _filterButton() {
    return TextIconButton(
        text: " Filtros |",
        icon: Icons.filter_list,
        onTap: this._createOverlayEntry);
  }
}
