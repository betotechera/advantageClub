// Códigos desenvolvidos por Alberto Techera para um projeto específico de Clube de Benefícios
// Estão wm fase de atualizados em Setembro/2021

import 'package:advantage_club/store/app_state.dart';
import 'package:advantage_club/store/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'components/bars/categories_bar.dart';
import 'components/bars/search_bar.dart';
import 'components/advantage/advantage_card.dart';
import 'components/side_menu.dart';
import 'components/home_banner.dart';
import 'model_views/advantage_view.dart';

void main() {
  Store<AppState> store =
      Store<AppState>(appStateReducer, initialState: AppState.initalState());
  runApp(MyApp(store: store,));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({required this.store});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: this.store,
        child: MaterialApp(
          title: 'Clube Wingoo',
          theme: ThemeData(
              brightness: Brightness.light,
              canvasColor: Colors.white,
              backgroundColor: Colors.white,
              primaryColorDark: Color.fromRGBO(56, 58, 53, 1),
              primaryColorLight: Color.fromRGBO(255, 198, 88, 1),
              primaryColorBrightness: Brightness.light,
              primaryColor: Colors.white),
          home: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<CategoriesMenuState> _categoryKey =
      GlobalKey<CategoriesMenuState>();

  ScrollController _scrollController = ScrollController();

  bool _showFloatButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawerEnableOpenDragGesture: true,
        floatingActionButton: AnimatedOpacity(
          opacity: _showFloatButton ? 1 : 0,
          duration: Duration(milliseconds: 240),
          child: buildFloatingActionButton(),
        ),
        drawer: DrawerWidget(
          callback: removeOverleyBar,
          context: context,
        ),
        body: CustomScrollView(controller: _scrollController, slivers: [
          SliverAppBar(
            title: Search(context, onIconTapped: (int value) { (1); },),
            pinned: true,
          ),
          StoreConnector<AppState, AdvantageView>(
              builder: (BuildContext context, advModel) {
                _scrollController.addListener(() {
                  showFloatButton();
                  loadMoreNearlyEnd(advModel, context);
                });
                var currentList = [
                  CategoriesMenu(key: _categoryKey),
                  HomeBanner(),
                  _listLoading()
                ];
                if (advModel.advantages.isNotEmpty) {
                  currentList
                    ..removeLast()
                    ..addAll(createList(advModel, context));
                }
                if (advModel.notFound) {
                  currentList
                    ..removeLast()
                    ..add(_notFoundWidget());
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return currentList[index];
                    },
                    childCount: currentList.length,
                    semanticIndexOffset: 3,
                  ),
                );
              },
              converter: (Store<AppState> store) {
                return AdvantageView.create(store);
              },
              onInit: (store) => AdvantageView.create(store).loadAdvantages())
        ]));
  }

  void removeOverleyBar(bool open) {
    try {
      if (open) {
        _categoryKey.currentState!.overlayEntry.remove();
      }
    } catch (e) {
      print(e);
      print(_categoryKey.currentState);
    }
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.keyboard_arrow_up, color: Theme.of(context).primaryColorLight),
      tooltip: "Voltar para o topo",
      mini: true,
      backgroundColor: Theme.of(context).primaryColorDark,
      onPressed: () {
        _scrollController.animateTo(0,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(seconds: 1));
      },
    );
  }

  void showFloatButton() {
    if (_scrollController.position.userScrollDirection !=
        ScrollDirection.forward) {
      setState(() {
        _showFloatButton = true;
      });
    }
    if (_scrollController.position.userScrollDirection !=
        ScrollDirection.reverse) {
      setState(() {
        _showFloatButton = false;
      });
    }
  }

  Widget _notFoundWidget() {
    return Container(
        height: 150,
        padding: EdgeInsets.all(50),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.error, color: Theme.of(context).primaryColorLight),
            Spacer(),
            Text("Nenhum resultado encontrado",
                style: TextStyle(
                    fontSize: 18.0, color: Theme.of(context).primaryColorLight, fontFamily: "Gotik")),
          ],
        ));
  }

  void loadMoreNearlyEnd(AdvantageView advModel, BuildContext context) {
    final eagerMargin = 800;
    var isEnd = (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - eagerMargin) &&
        !_scrollController.position.outOfRange &&
        (_scrollController.position.axisDirection == AxisDirection.down);
    if (isEnd) {
      advModel.loadAdvantages();
    }
  }

  List<Widget> createList(AdvantageView view, BuildContext context) {
    List<Widget> widgets = view.advantages
        .map<Widget>((advantage) => AdvantageCard(advantage: advantage))
        .toList();

    if (view.lastPage)
      widgets.add(SizedBox(height: 20));
    else
      widgets.add(_listLoading());
    return widgets;
  }

  Padding _listLoading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorLight)),
    );
  }
}
