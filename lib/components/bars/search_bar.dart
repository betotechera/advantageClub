import 'package:advantage_club/model_views/serarch_view.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Search extends StatefulWidget {
  Search(content, {required this.onIconTapped});
  ValueChanged<int> onIconTapped;
  @override
  State createState() => SearchState();
}

class SearchState extends State<Search> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Center(
        child: Theme(
            data: ThemeData(hintColor: Colors.transparent),
            child: StoreConnector<AppState, SearchView>(
              converter: (store) {
                return SearchView.create(store);
              },
              builder: (context, searchView) {
                final _searchController = TextEditingController(text: searchView.state.currentSearchContent);
                return TextFormField(
                  controller: _searchController,
                  onFieldSubmitted: (value) => searchView.loadSarch(value),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorLight)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark)),
                      suffixIcon: GestureDetector(
                          onTap: () =>
                              searchView.loadSarch(_searchController.text),
                          child: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColorDark,
                            size: 28.0,
                          )),
                      hintText: "O que você procura?",
                      contentPadding: const EdgeInsets.only(left: 30),
                      hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: "Gotik",
                          fontWeight: FontWeight.w400)),
                );
              },
            )),
      ),
    );
  }
}
