import 'package:flag_app/controllers/settings_controller.dart';
import 'package:flag_app/widget/buttons/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import '../controllers/sound_controller.dart';
import '../helper/app_colors.dart';
import '../helper/dimensions.dart';
import '../widget/background_image.dart';
import '../widget/popup/change_language_dialog.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

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
                Padding(
                  padding: EdgeInsets.all(Dimensions.height10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Get.find<SoundController>().clickSound();
                        Get.back();
                      },
                      child: Container(
                        width: Dimensions.width20 * 2,
                        height: Dimensions.height20 * 2,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20 * 2),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      SettingsButton(
                        title: 'Language'.tr,
                        onTap: () {
                          buildLanguageDialog();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: Dimensions.width10),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/image/flags/${Get.locale.toString().split("_")[1].toLowerCase()}.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height20,
                      ),
                      GetBuilder<SoundController>(builder: (soundController) {
                        return SettingsButton(
                          title: 'Sound'.tr,
                          onTap: () {
                            soundController
                                .soundSettingsSave(!soundController.getSoundOn);
                          },
                          child: Switch(
                            value: soundController.getSoundOn,
                            onChanged: (value) {
                              soundController.soundSettingsSave(value);
                            },
                            activeColor: AppColors.mainColor,
                            inactiveThumbColor: AppColors.mainColor,
                            inactiveTrackColor: AppColors.textColorGray,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                          height: Dimensions.height30 * 10,
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.width10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Dimensions.height30,
                                ),
                                Text('Made by Jackie H. Jensen\n',
                                    textScaleFactor: 1),
                                Text('Sound Effect from Pixabay\n',
                                    textScaleFactor: 1),
                                Text('Countries are from Djiass mapicon\n',
                                    textScaleFactor: 1),
                              ],
                            ),
                          )),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30)),
                      enableDrag: true,
                    );
                  },
                  child: Text(
                    'Credits'.tr,
                    style: TextStyle(color: AppColors.textColorGray),
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
