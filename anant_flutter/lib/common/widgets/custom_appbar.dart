import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anant_flutter/common/widgets/circular_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Title text for the app bar.
  final String title;
  // Optional parameters allow you to customize the background and status bar colors.
  final Color backgroundColor;
  final Color statusBarColor;
  // Customize the height of the toolbar.
  final double toolbarHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor = const Color(0xFF3c6673),
    this.statusBarColor = const Color(0xFF3c6673),
    this.toolbarHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      // The foregroundColor here can affect the default text and icon color.
      foregroundColor: backgroundColor,
      leading: const CircularBackButton(),
      titleSpacing: 0,
      toolbarHeight: toolbarHeight,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  // The preferred size is required so Flutter knows how much space the AppBar needs.
  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
