import 'package:advantage_club/components/bars/search_bar.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:redux/redux.dart';

import 'advantage_view.dart';

class SearchView {
  final Function loadSarch;
  final AppState state;

  SearchView(this.state, this.loadSarch);

  factory SearchView.create(Store<AppState> store) {
    _loadSarch(content) async {
        store.dispatch(Search(content, onIconTapped: (int value) {  },));
        var _advantageView = AdvantageView.create(store);
        _advantageView.clearAdvList();
        _advantageView.loadAdvantages();
    }

    return SearchView(store.state, _loadSarch);
  }
}