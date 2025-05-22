import 'package:flutter/material.dart';
import '../../../shared/utils/constants/sizes.dart';

// ignore: must_be_immutable'

class OnboardingPape extends StatelessWidget {
  const OnboardingPape({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Padding(
                padding: const EdgeInsets.all(MSizes.defaultSpace),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(image),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: MSizes.spaceBtwItems),
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
