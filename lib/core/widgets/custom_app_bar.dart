import 'package:flutter/material.dart';
import '../constants/app_bar_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBarConstants.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppBarConstants.titleStyle),
      backgroundColor: AppBarConstants.backgroundColor,
      elevation: AppBarConstants.elevation,
      iconTheme: AppBarConstants.iconTheme,
      leading: leading,
      actions: actions,
      centerTitle: false,
    );
  }
}