import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String imagePath;
  final double height;

  const LogoWidget({
    Key? key,
    required this.imagePath,
    this.height = 246,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
