import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdsState extends Equatable {}

class InitialAdsState extends AdsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingAdsState extends AdsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadedAdsState extends AdsState {
  final BannerAd bannerAd;

  LoadedAdsState(this.bannerAd);

  @override
  // TODO: implement props
  List<Object?> get props => [bannerAd];
}

class ErrorAdsState extends AdsState {
  final String errorMsg;

  ErrorAdsState(this.errorMsg);

  @override
  // TODO: implement props
  List<Object?> get props => [errorMsg];
}
