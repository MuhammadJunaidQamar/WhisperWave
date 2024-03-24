import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double pictureWidth;
  final double pictureHeight;
  const Logo({
    super.key,
    required this.pictureWidth,
    this.pictureHeight = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/WhisperWave.png',
      width: pictureWidth,
      height: pictureHeight != 0.0 ? pictureHeight : null,
    );
  }
}
