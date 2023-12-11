import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_text_flutter/business_logic/banner_ads_cubit/google_ads_state.dart';

import '../../utils/ad_helper.dart';

class AdsCubit extends Cubit<AdsState> {
  BannerAd? bannerAdan;

  AdsCubit(e) : super(InitialAdsState());

  initialiseBanner() async {
    debugPrint("******** Initialised Banner Ads*********");
    emit(LoadingAdsState());
    bannerAdan = BannerAd(
        // Change Banner Size According to Ur Need
        size: AdSize.largeBanner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          debugPrint("******** Banner Ads Loaded state *********");
          emit(LoadedAdsState(bannerAdan!));
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          debugPrint("******** Banner Ads Error state *********");
          emit(ErrorAdsState('Issue in Banner Load ${error.toString()}'));
          ad.dispose();
        },
        ),
        request: const AdRequest())
      ..load();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    bannerAdan?.dispose();
    return super.close();
  }
}
