import 'package:firebase_admob/firebase_admob.dart';
import 'package:pm/config/application.dart';

const String interstitialUnitId = 'ca-app-pub-2118868664212790/9463676538';
const String awardVideoUnitId = 'ca-app-pub-2118868664212790/7990970896';

const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

InterstitialAd createInterstitialAd(MobileAdListener listener) {
  return InterstitialAd(
    adUnitId:
        Application.debug ? InterstitialAd.testAdUnitId : interstitialUnitId,
    targetingInfo: targetingInfo,
    listener: listener,
  );
}

BannerAd createBannerAd(MobileAdListener listener) {
  return BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: listener,
  );
}

RewardedVideoAd createVideoAd(RewardedVideoAdListener listener) {
  RewardedVideoAd.instance.load(
    adUnitId:
        Application.debug ? RewardedVideoAd.testAdUnitId : awardVideoUnitId,
    targetingInfo: targetingInfo,
  );
  RewardedVideoAd.instance.listener = listener;
  return RewardedVideoAd.instance;
}
