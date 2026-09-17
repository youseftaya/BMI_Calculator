import 'package:flutter/material.dart';
import 'custom_circle_button.dart';

class CounterCard extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color backgroundColor;
  final Color textColor;

  final Color buttonBackgroundColor;
  final Color buttonIconColor;

  const CounterCard({
    Key? key,
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.backgroundColor,
    required this.textColor,
    required this.buttonBackgroundColor,
    required this.buttonIconColor,
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
          Text(
            title,
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 18,
            ),
          ),

          Text(
            '$value',
            style: TextStyle(
              color: textColor,
              fontSize: 39,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: CustomCircleIconButton(
                  icon: Icons.remove,
                  backgroundColor: buttonBackgroundColor,
                  iconColor: buttonIconColor,
                ),
              ),

              const SizedBox(width: 16),

              GestureDetector(
                onTap: onIncrement,
                child: CustomCircleIconButton(
                  icon: Icons.add,
                  backgroundColor: buttonBackgroundColor,
                  iconColor: buttonIconColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}