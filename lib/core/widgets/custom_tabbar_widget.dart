import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_colors.dart';
import '../utils/shared.dart';
import 'custom_text_widget.dart';

class CustomTabbarWidget extends StatelessWidget {
  final TabController? controller;
  final List<String> tabs;
  final bool allowPadding;
  final int currentIndex;
  final Color? indicatorColor;
  final Function(int)? onTabTapped;

  const CustomTabbarWidget(
      {super.key,
      this.controller,
      this.indicatorColor,
      required this.tabs,
      this.allowPadding = true,
      required this.currentIndex,
      this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    final currentIndex = ValueNotifier<int>(controller?.index ?? 0);
    controller?.addListener(() {
      if (controller?.indexIsChanging ?? false) return;

      currentIndex.value = controller?.index ?? 0;
    });
    return TabBar(
      padding: allowPadding
          ? EdgeInsets.symmetric(horizontal: UIConstants.horizontalPaddingValue)
          : EdgeInsets.zero,
      isScrollable: false,
      controller: controller,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Theme.of(context).colorScheme.primaryContainer,
      indicatorWeight: 3.h,
      indicator: BoxDecoration(
        color: indicatorColor ?? AppLightColors.primaryLightColor,
        borderRadius: BorderRadius.circular(5.r),
        backgroundBlendMode: BlendMode.darken,
        boxShadow: [
          BoxShadow(
            color: SharedColors.seaBlue,
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.w,
        ),
      ),
      onTap: (index) {
        currentIndex.value = index;
        if (onTabTapped != null) onTabTapped!(index);
      },
      tabs: List.generate(
        tabs.length,
        (index) => Tab(
          child: ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, idx, child) {
                final bool isSelected = idx == index;
                return CustomTextWidget(
                  text: tabs[index],
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  height: 1,
                );
              }),
        ),
      ),
    );
  }
}
