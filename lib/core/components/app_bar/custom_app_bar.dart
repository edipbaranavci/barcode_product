import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../button/custom_icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final VoidCallback? onBackTap;
  final bool isHideBackButton;

  const CustomAppBar({
    super.key,
    this.onBackTap,
    required this.title,
    this.isHideBackButton = false,
  }) : preferredSize = const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: context.general.textTheme.titleLarge),
      centerTitle: true,
      leading: isHideBackButton
          ? const SizedBox.shrink()
          : Center(
              child: CustomIconButton(
                iconData: Icons.chevron_left,
                onTap: onBackTap ?? () => context.route.pop(),
                toolTip: 'Geri',
              ),
            ),
      automaticallyImplyLeading: true,
    );
  }
}
