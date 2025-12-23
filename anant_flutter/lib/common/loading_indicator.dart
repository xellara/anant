import 'package:anant_flutter/anant_progress_indicator.dart';
import 'package:flutter/material.dart';

/// Simple wrapper for in-app loading indicator
/// Use this instead of CircularProgressIndicator throughout the app
class LoadingIndicator extends StatelessWidget {
  final double? size;
  
  const LoadingIndicator({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 60,
      height: size ?? 60,
      child: const AnantProgressIndicator(), // Transparent by default
    );
  }
}
