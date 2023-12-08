

import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class  GoogleAds{
  BannerAd? bannerAd;
  // Geçiş Reklamları
  InterstitialAd? interstitialAd;
  void loadInterstitialAd({bool showAfterLoad=false}) {

    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712", //test kodudur
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {

            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
            if(showAfterLoad)showInterstitialAd();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) { print("**************Reklam Yüklenmedi");
          },
        ));
  }
  void showInterstitialAd(){
    if(interstitialAd!=null){
      print("****************Reklam Yüklendi");
      interstitialAd!.show();
    }
  }

  void loadBannerAd({required VoidCallback adlLoaded}) {
     bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
              bannerAd=ad as BannerAd;
              adlLoaded();

        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {

          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
}