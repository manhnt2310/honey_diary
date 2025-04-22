import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage("lib/assets/image/I.jpg"),
        //   fit: BoxFit.cover,
        // ),
        color: Colors.cyan.shade100,
      ),
    );
  }
}
