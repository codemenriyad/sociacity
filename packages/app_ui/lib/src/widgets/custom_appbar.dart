// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    required this.centerTitle,
    required this.autoLeading,
    super.key,
  });
  final String title;
  final bool centerTitle;
  final bool autoLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: UITextStyle.headline6.copyWith(color: AppColors.white),
      ),
      actions: const [],
      centerTitle: centerTitle,
      automaticallyImplyLeading: autoLeading,
      iconTheme: const IconThemeData(color: AppColors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
