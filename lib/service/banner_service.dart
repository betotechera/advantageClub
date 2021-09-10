import 'package:advantage_club/model/banner.dart';
import 'package:requests/requests.dart';

import '../config.dart';

class BannerService {

  Future<List<WingooBanner>> banners() async {
    var url = "${Config.api}/hirers/banners?location=NOT_LOGGED_IN_USER_HOME&location=USER_HOME_ALWAYS";
    var response = await Requests.get(url);
    final parsed = response.json();
    var result = parsed['items'].map<WingooBanner>((json) => WingooBanner.fromJson(json)).toList();
    return result;
  }

  Future<List<WingooBanner>> myBanners() async {
    var url = "${Config.api}/hirers/me/banners?location=LOGGED_IN_USER_HOME&location=USER_HOME_ALWAYS";
    var response = await Requests.get(url);
    final parsed = response.json();
    var result = parsed['items'].map<WingooBanner>((json) => WingooBanner.fromJson(json)).toList();
    return result;
  }
  
}