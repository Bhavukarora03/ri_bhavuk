import 'package:flutter/material.dart';
import 'package:ri_bhavuk/theme/theme.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final String color;
  final IconData? icon;

  const Button({
    super.key,
    required this.onPressed,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    switch (color) {
      case 'primary':
        backgroundColor = primaryColor;
        foregroundColor = secondaryColor;
        break;
      case 'secondary':
        backgroundColor = secondaryColor;
        foregroundColor = primaryColor;
        break;
      default:
        backgroundColor = primaryColor;
        foregroundColor = Colors.white;
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon),
          if (icon != null) const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
