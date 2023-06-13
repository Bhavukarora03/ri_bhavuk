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
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Text(label, style:  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03)),
    );
  }
}
