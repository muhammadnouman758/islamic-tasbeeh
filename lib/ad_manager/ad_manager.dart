// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:tasbih/ad_manager/ad_helper.dart';
//
//
// class AdManager {
//   static final AdManager _instance = AdManager._internal();
//
//   factory AdManager() {
//     return _instance;
//   }
//
//   AdManager._internal();
//
//   int _bannerRequestCount = 0;
//   int _interstitialRequestCount = 0;
//   int _rewardedRequestCount = 0;
//
//   final int _maxRequests = 3;
//
//   BannerAd? _bannerAd;
//   InterstitialAd? _interstitialAd;
//   RewardedAd? _rewardedAd;
//
//   Future<void> initialize() async {
//     await MobileAds.instance.initialize();
//   }
//
//   BannerAd? getBannerAd() {
//     if (_bannerRequestCount >= _maxRequests) {
//       return null;
//     }
//
//     if (_bannerAd == null) {
//       _bannerAd = BannerAd(
//         adUnitId: AdsHelper.BannerAds,
//         size: AdSize.banner,
//         request: AdRequest(),
//         listener: BannerAdListener(
//           onAdLoaded: (_) {
//           },
//           onAdFailedToLoad: (ad, error) {
//
//             ad.dispose();
//             _bannerAd = null;
//           },
//         ),
//       )..load();
//
//       _bannerRequestCount++;
//     }
//
//     return _bannerAd;
//   }
//
//   void loadInterstitialAd() {
//     if (_interstitialRequestCount >= _maxRequests) {
//
//       return;
//     }
//
//     InterstitialAd.load(
//       adUnitId: AdsHelper.InterstitialAds,
//       request: AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//
//           _interstitialAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//
//         },
//       ),
//     );
//
//     _interstitialRequestCount++;
//   }
//
//   void showInterstitialAd() {
//     if (_interstitialAd != null) {
//       _interstitialAd!.show();
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//
//           ad.dispose();
//           _interstitialAd = null;
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//
//           ad.dispose();
//           _interstitialAd = null;
//         },
//       );
//     } else {
//
//     }
//   }
//
//   void loadRewardedAd() {
//     if (_rewardedRequestCount >= _maxRequests) {
//       return;
//     }
//
//     RewardedAd.load(
//       adUnitId: "ca-app-pub-2939653537074181/6425669555",
//       request: AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (ad) {
//
//           _rewardedAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//
//         },
//       ),
//     );
//
//     _rewardedRequestCount++;
//   }
//
//   void showRewardedAd({required Function onReward}) {
//     if (_rewardedAd != null) {
//       _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
//
//         onReward();
//       });
//
//       _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (ad) {
//
//           ad.dispose();
//           _rewardedAd = null;
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//
//           ad.dispose();
//           _rewardedAd = null;
//         },
//       );
//     } else {
//
//     }
//   }
//
//   void disposeAds() {
//     _bannerAd?.dispose();
//     _interstitialAd?.dispose();
//     _rewardedAd?.dispose();
//     _bannerAd = null;
//     _interstitialAd = null;
//     _rewardedAd = null;
//   }
// }
