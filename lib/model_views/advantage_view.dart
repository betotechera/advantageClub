import 'package:advantage_club/model/advantage.dart';
import 'package:advantage_club/service/advantage_service.dart';
import 'package:advantage_club/store/actions.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:redux/redux.dart';

class AdvantageView {
  final Store<AppState> store;
  final List<Advantage> advantages;
  final bool lastPage;
  final bool notFound;
  //static int _currentPage;

  AdvantageView(this.advantages, this.lastPage, this.store, this.notFound,);

  factory AdvantageView.create(Store<AppState> store) {
    final pagination = store.state.advantagePagination;
    return AdvantageView(
        pagination.advantages, pagination.lastPage, store, pagination.notFound);
  }
  void clearAdvList() {
    //_currentPage = null;
    store.dispatch(ClearAdvantages());
  }

  void loadAdvantages() async {
    final int currentPage = store.state.advantagePagination.nextPage;
    var state = store.state;
    if (!state.advantagePagination.lastPage) {
      //_currentPage = currentPage;
      final result = await AdvantageService().advantages(
          page: currentPage.toString(),
          searchContent: state.currentSearchContent,
          categorySlugName: state.currentCategory.slugName,
          subcategorySlugName: getParamsFor(state, CheckType.SUBCATEGORY),
          marketingType: getParamsFor(state, CheckType.ADVANTAGE_TYPE));
      store.dispatch(LoadAdvantages(
          result.items, currentPage + 1, !result.hasNext, result.total == 0));
    }
  }

  Iterable<String> getParamsFor(AppState state, CheckType type) =>
      state.checkboxes.where((e) => e.type == type).map((e) => e.code);
}