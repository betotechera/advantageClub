import 'package:advantage_club/components/generic/Text_icon_button.dart';
import 'package:advantage_club/model/category.dart';
import 'package:advantage_club/model/checkable_object.dart';
import 'package:advantage_club/model_views/advantage_view.dart';
import 'package:advantage_club/model_views/category_view.dart';
import 'package:advantage_club/store/actions.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'category_item.dart';
import 'package:redux/redux.dart';

class CategoriesMenuOver extends StatefulWidget {
  CategoriesMenuOver({required this.overlayEntry});
  final OverlayEntry overlayEntry;

  @override
  State createState() => CategoriesMenuOverState();
}

class CategoriesMenuOverState extends State<CategoriesMenuOver> {

  static final double _defaultHeight = 40;
  double _height = _defaultHeight;
  double _previouY = 0;
  bool _showFilters = false;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  get onTap => null;

  void initState() {
    super.initState();
    _crossFadeState = CrossFadeState.showSecond;
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          _height = _maxSize();
          _crossFadeState = CrossFadeState.showFirst;
        }));
  }

  double _maxSize() {
    return MediaQuery.of(context).size.height / 5 * 4;
  }

  Function _categoryClose() {
    var viewHeight = _maxSize();
    return () {
      setState(() {
        if (_height == viewHeight) {
          _showFilters = false;
          _height = _defaultHeight;
          _crossFadeState = CrossFadeState.showSecond;
        } else {
          _height = viewHeight;
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Material(
        child: StoreConnector<AppState, AdvantageView>(
            converter: (Store<AppState> store) {
          return AdvantageView.create(store);
        }, builder: (BuildContext context, advModel) {
          return AnimatedContainer(
            onEnd: () {
              if (_height == _defaultHeight) {
                advModel.clearAdvList();
                advModel.loadAdvantages();
                widget.overlayEntry.remove();
              }
              if (_height == _maxSize()) {
                setState(() {
                  _showFilters = true;
                });
              }
            },
            duration: Duration(milliseconds: 480),
            curve: Curves.fastOutSlowIn,
            height: _height,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 3, color: Theme.of(context).primaryColorLight)),
                color: Theme.of(context).primaryColorDark),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StoreConnector<AppState, CategoryView>(
                    builder: (BuildContext context, categoriesView) {
                      return categoriesLine(categoriesView.categories);
                    },
                    converter: (Store<AppState> store) {
                      return CategoryView.create(store);
                    },
                  ),
                  filterBoxes()
                ],
              ),
              _clearButton(),
              _search()
            ]),
          );
        }),
      ),
    );
  }

  Widget _clearButton() {
    if (_showFilters) {
      return StoreConnector<AppState, _CheckBoxView>(converter: (store) {
        return _CheckBoxView.create(store);
      }, builder: (context, subcategoryView) {
        return Positioned(
            bottom: 0,
            left: 0,
            child: TextIconButton(
                text: " Limpar",
                icon: Icons.clear_all,
                onTap: subcategoryView.clearFilters));
      });
    }
    return Container();
  }

  Widget _search() {
    if (_showFilters) {
      return StoreConnector<AppState, CategoryView>(converter: (store) {
        return CategoryView.create(store);
      }, builder: (context, categoryView) {
        return Positioned(
            bottom: 0,
            right: 0,
            child: TextIconButton(
                text: " Buscar",
                icon: Icons.search,
                onTap: () {
                  setState(() {
                    _showFilters = false;
                    _height = _defaultHeight;
                  });
                  categoryView.loadCategories();
                }));
      });
    }
    return Container();
  }

  void onVerticalDragUpdate(details) {
    setState(() {
      if (_previouY == 0) {
        _previouY = details.localPosition.dy;
        return;
      }
      if (_previouY >= details.localPosition.dy) {
        _showFilters = false;
        _height = _defaultHeight;
        _crossFadeState = CrossFadeState.showSecond;
      }
    });
  }

  Widget filterBoxes() {
    List<CheckableObject> types = [
      CheckableObject("Acesso a lojas virtuais (link externo)",
          "ONLINE_STORE_ACCESS", CheckType.ADVANTAGE_TYPE),
      CheckableObject("Cupons de descontos lojas virtuais",
          "ONLINE_STORE_DISCOUNT_COUPON", CheckType.ADVANTAGE_TYPE),
      CheckableObject("Cupons de descontos lojas físicas",
          "PHYSICAL_STORE_DISCOUNT_COUPON", CheckType.ADVANTAGE_TYPE)
    ];
    if (_showFilters) {
      return Container(
        height: _maxSize() - 80,
        width: MediaQuery.of(context).size.width,
        child: Scrollbar(
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20),
            children: [
              FilterBox(title: "Tipos de Oferta", items: types, ),
              StoreConnector<AppState, Category>(converter: (store) {
                return store.state.currentCategory;
              }, builder: (context, category) {
                 return FilterBox(
                      title: "Subcategorias", items: category.subcategories);
                //return Container();
              })
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Container categoriesLine(List<Category> categories) {
    var categoryList = [_closeItem()]..addAll(categories
        .map<Widget>((c) => CategoryItemWidget(category: c, onTap: onTap,))
        .toList());
    return Container(
        height: 37,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            return categoryList[index];
          },
        ));
  }

  Widget _closeItem() {
    return AnimatedCrossFade(
      firstChild: TextIconButton(
          text: " Fechar ", icon: Icons.close, onTap: this._categoryClose()),
      secondChild: TextIconButton(
          text: " Filtros |",
          icon: Icons.filter_list,
          onTap: this._categoryClose()),
      crossFadeState: _crossFadeState,
      duration: Duration(milliseconds: 480),
    );
  }
}

class FilterBox extends StatelessWidget {
  const FilterBox({
    required this.title,
    required this.items,
  });

  final String title;
  final List<CheckableObject> items;

  @override
  Widget build(BuildContext context) {
    var widgetItems = this
        .items
        .map<Widget>((item) =>
            StoreConnector<AppState, _CheckBoxView>(converter: (store) {
              return _CheckBoxView.create(store);
            }, builder: (context, subcategoryView) {
              return CheckableFilterItem(
                  text: item.text,
                  active: subcategoryView.checkboxes
                      .map((e) => e.code)
                      .contains(item.code),
                  onChanged: (bool value) {
                    subcategoryView.checkableObjectSelected(item);
                  });
            }))
        .toList();
    widgetItems.insert(0, _titleWidget(context));
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(children: widgetItems));
  }

  Column _titleWidget(BuildContext context) {
    return Column(children: [
      Text(title,
          style: TextStyle(
              color: Theme.of(context).primaryColorLight, fontSize: 20, fontWeight: FontWeight.w700)),
      SizedBox(height: 20)
    ]);
  }
}

class CheckableFilterItem extends StatelessWidget {
  const CheckableFilterItem({
    required String text,
    required this.onChanged,
    required this.active,
  })  : _text = text;

  final String _text;
  final Function onChanged;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(value: active, activeColor: Theme.of(context).primaryColorLight, onChanged: (bool? value) {  },),
        InkWell(
            onTap: () {
              onChanged(null);
            },
            child: Text(_text, style: TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 15)))
      ],
    );
  }
}

class _CheckBoxView {
  final List<CheckableObject> checkboxes;
  final Function(CheckableObject) checkableObjectSelected;
  final Function() clearFilters;

  _CheckBoxView(
      this.checkboxes, this.checkableObjectSelected, this.clearFilters);

  factory _CheckBoxView.create(Store<AppState> store) {
    var _checkableObjectSelected = (CheckableObject checkableObject) {
      store.dispatch(CheckSelected(checkableObject));
    };
    var _clearFilters = () {
      store.dispatch(ClearFilters());
    };

    return _CheckBoxView(
        store.state.checkboxes, _checkableObjectSelected, _clearFilters);
  }
}
