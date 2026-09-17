import 'package:flutter/material.dart';

class GenderCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final Color iconColor;

  const GenderCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 95,
            height: 95,
            color: iconColor,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 21,
            ),
          ),
        ],
      ),
    );
  }
}