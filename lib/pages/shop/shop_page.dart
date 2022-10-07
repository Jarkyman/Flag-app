import 'package:flag_app/controllers/hint_controller.dart';
import 'package:flag_app/controllers/shop_controller.dart';
import 'package:flag_app/helper/app_colors.dart';
import 'package:flag_app/widget/background_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../controllers/sound_controller.dart';
import '../../helper/ad_helper.dart';
import '../../helper/dimensions.dart';
import '../../widget/Top bar/app_bar_row_exit.dart';
import '../../widget/buttons/menu_button.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  void purchaseErrorSnackbar() {
    Get.snackbar('Purchase failed'.tr, 'Failed to buy, try again later'.tr,
        backgroundColor: Colors.red.withOpacity(0.4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundImage(
        child: SwipeDetector(
          onSwipeDown: (value) {
            Get.find<SoundController>().windSound();
            Get.back();
          },
          child: SafeArea(
            child: Column(
              children: [
                AppBarRowExit(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      MenuButton(
                        onTap: () async {
                          try {
                            await Purchases.purchaseProduct('flags_50_hints');
                            for (int i = 1; i <= 10; i++) {
                              Get.find<HintController>().addHint(5);
                            }
                            Get.find<SoundController>().completeSound();
                          } catch (e) {
                            debugPrint('Failed to purchase product.');
                            purchaseErrorSnackbar();
                          }
                        },
                        title: 'Buy 50 hints'.tr,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      MenuButton(
                        onTap: () async {
                          try {
                            await Purchases.purchaseProduct('flags_100_hints');
                            for (int i = 1; i <= 20; i++) {
                              Get.find<HintController>().addHint(5);
                            }
                            Get.find<SoundController>().completeSound();
                          } catch (e) {
                            debugPrint('Failed to purchase product.');
                            purchaseErrorSnackbar();
                          }
                        },
                        title: 'Buy 100 hints'.tr,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      MenuButton(
                        onTap: () async {
                          try {
                            await Purchases.purchaseProduct('flags_500_hints');
                            for (int i = 1; i <= 100; i++) {
                              Get.find<HintController>().addHint(5);
                            }
                            Get.find<SoundController>().completeSound();
                          } catch (e) {
                            debugPrint('Failed to purchase product.');
                            purchaseErrorSnackbar();
                          }
                        },
                        title: 'Buy 500 hints'.tr,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      MenuButton(
                        active: !Get.find<ShopController>().isLevelsUnlocked,
                        onTap: () async {
                          if (!Get.find<ShopController>().isLevelsUnlocked) {
                            try {
                              await Purchases.purchaseProduct(
                                  'flags_unlock_levels');
                              Get.find<ShopController>().levelsUnlockSave(true);
                              Get.find<SoundController>().completeSound();
                            } catch (e) {
                              debugPrint('Failed to purchase product.');
                              purchaseErrorSnackbar();
                            }
                          } else {
                            Get.snackbar(
                              'Levels unlocked',
                              'You have already removed all levels',
                              backgroundColor:
                                  AppColors.correctColor.withOpacity(0.4),
                            );
                          }
                        },
                        title: 'Unlock all levels'.tr,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      MenuButton(
                        active: !Get.find<ShopController>().isAdsRemoved,
                        onTap: () async {
                          if (!Get.find<ShopController>().isLevelsUnlocked) {
                            try {
                              await Purchases.purchaseProduct(
                                  'flags_remove_ads');
                              Get.find<ShopController>().removeAdsSave(true);
                              Get.find<SoundController>().completeSound();
                              debugPrint('Removed adds');
                            } catch (e) {
                              debugPrint('Failed to purchase product.');
                              purchaseErrorSnackbar();
                            }
                          } else {
                            Get.snackbar(
                              'Levels unlocked'.tr,
                              'You have already removed all levels'.tr,
                              backgroundColor:
                                  AppColors.correctColor.withOpacity(0.4),
                            );
                          }
                        },
                        title: 'Remove ads'.tr,
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      MenuButton(
                        onTap: () {
                          _rewardedAd?.show(
                            onUserEarnedReward: (_, reward) {
                              Get.find<HintController>().addHint(3);
                              Get.find<SoundController>().completeSound();
                            },
                          );
                        },
                        title: 'Watch video (3 hints)'.tr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
