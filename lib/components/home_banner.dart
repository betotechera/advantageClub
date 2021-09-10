import 'package:advantage_club/model/banner.dart';
import 'package:advantage_club/model_views/banner_view.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeBanner extends StatefulWidget {
  @override
  _HomeBannerState createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WingooBanner>>(
        converter: (store) {
          return store.state.banners;
        },
        builder: (context, List<WingooBanner> banners) {
          if (banners.isNotEmpty) {
            return Container(
                height: 160,
                child: Carousel(
                  boxFit: BoxFit.fill,
                  dotColor: Color(0xFF6991C7).withOpacity(0.8),
                  dotSize: 3.5,
                  dotSpacing: 18.0,
                  dotBgColor: Colors.transparent,
                  showIndicator: true,
                  autoplayDuration: const Duration(seconds: 10),
                  overlayShadowSize: 0.9,
                  images: banners
                      .map((banner) => GestureDetector(
                          onTap: () async {
                            if (!banner.internalLink)
                              await launch(banner.linkUrl);
                          },
                          child: Image(
                              image: NetworkImage(banner.imageUrl),
                              fit: BoxFit.fill)))
                      .toList(),
                ));
          }
          return Container();
        },
        onInit: (store) => BannerView.create(store).loadBanners());
  }
}
