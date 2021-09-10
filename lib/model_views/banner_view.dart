import 'package:advantage_club/service/banner_service.dart';
import 'package:advantage_club/store/actions.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:redux/redux.dart';

class BannerView {
  final Function loadBanners;

  BannerView(this.loadBanners);

  factory BannerView.create(Store<AppState> store) {
    _loadBanners() async {
      final banners = await BannerService().banners();
      store.dispatch(LoadBanners(banners));
    }

    return BannerView(_loadBanners);
  }
}
