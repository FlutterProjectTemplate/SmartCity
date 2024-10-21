import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoNotification extends StatelessWidget {
  // final String animationString;
  final String title;
  const NoNotification({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/lottie/notification.json',
              animate: true,
              fit: BoxFit.contain,
              height: 250,
              width: 250,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueGrey, fontWeight: FontWeight.w400, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
