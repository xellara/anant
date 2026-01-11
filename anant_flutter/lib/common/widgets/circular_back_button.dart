import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CircularBackButton extends StatelessWidget {
  const CircularBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 4.0, right: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(PhosphorIconsStyle.bold)),
          color: Theme.of(context).primaryColor,
          iconSize: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(), // Removes default constraints
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}
