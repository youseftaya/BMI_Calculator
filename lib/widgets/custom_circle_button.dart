import 'package:flutter/material.dart';

class CustomCircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const CustomCircleIconButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        color: iconColor,
        size: 22,
      ),
    );
  }
}