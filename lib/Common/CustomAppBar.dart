import 'package:flutter/material.dart';

import 'BlinkingText.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final String finalTime;
  final String nextTime;

  const CustomAppBar({
    Key? key,
    required this.titleText,
    required this.finalTime,
    required this.nextTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              BlinkingText(text: titleText),
              const SizedBox(width: 16),
              // const DateDisplayWidget(),
            ],
          ),

        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
