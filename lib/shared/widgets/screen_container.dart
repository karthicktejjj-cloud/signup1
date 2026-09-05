import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive.dart';

/// Responsive, keyboard-safe, scrollable container with max width clamping
/// to ensure beautiful presentation on small phones, standard phones, and tablets.
class ScreenContainer extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const ScreenContainer({
    super.key,
    required this.child,
    this.scrollable = true,
    this.padding,
    this.appBar,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.horizontalPadding(context);

    Widget content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppDimensions.maxContentWidth,
        ),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppDimensions.space24,
              ),
          child: child,
        ),
      ),
    );

    if (scrollable) {
      content = SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        child: content,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
