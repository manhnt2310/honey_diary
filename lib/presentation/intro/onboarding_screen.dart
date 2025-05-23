import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';
import '../../shared/utils/constants/image_strings.dart';
import '../../shared/utils/constants/text_strings.dart';
import 'widgets/onboarding_dot_navigation.dart';
import 'widgets/onboarding_next_button.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Page View
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnboardingPape(
                image: ImageStrings.love,
                title: TextStrings.title1,
                subTitle: TextStrings.subTitle1,
              ),
              OnboardingPape(
                image: ImageStrings.onboarding2,
                title: TextStrings.title2,
                subTitle: TextStrings.subTitle2,
              ),
              OnboardingPape(
                image: ImageStrings.onboarding3,
                title: TextStrings.title3,
                subTitle: TextStrings.subTitle3,
              ),
            ],
          ),

          // Skip Button
          const OnboardingSkip(),

          // Dot navigation
          const OnBoardingDotNavigation(),

          // Next Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
