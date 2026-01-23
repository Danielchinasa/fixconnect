import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool useSafeArea;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.useSafeArea = true,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    } else {
      content = Padding(
        padding: EdgeInsets.all(AppSpacing.pagePadding),
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: appBar,
      body: content,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
