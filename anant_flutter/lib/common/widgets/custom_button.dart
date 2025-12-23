import 'package:anant_flutter/config/role_theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon; // Marked as optional
  final String label;
  final EdgeInsets padding; // New padding parameter

  const CustomButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.padding = const EdgeInsets.symmetric(vertical: 16), // default padding
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient ?? 
             LinearGradient(
               colors: [
                 Theme.of(context).primaryColor, 
                 Theme.of(context).primaryColor
               ]
             ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: icon != null 
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(label),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: padding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: padding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(label),
              ),
      ),
    );
  }
}
