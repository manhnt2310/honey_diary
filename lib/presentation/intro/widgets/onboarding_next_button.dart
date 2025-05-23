import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../shared/utils/constants/colors.dart';
import '../../../shared/utils/constants/sizes.dart';
import '../../../shared/utils/device/device_utility.dart';
import '../../../shared/utils/helpers/helper_functions.dart';
import '../onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = MHelperFunctions.isDarkMode(context);

    return Positioned(
      right: MSizes.defaultSpace,
      bottom: MDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          minimumSize: const Size(46, 46),
          backgroundColor: dark ? MColors.primary : Colors.pinkAccent,
        ),
        child: const Icon(Iconsax.arrow_right_3, color: Colors.white, size: 25),
      ),
    );
  }
}
