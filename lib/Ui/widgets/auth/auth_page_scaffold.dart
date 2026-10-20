import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

/// Layout shared by the authentication screens.
///
/// Keeps the dark background, the scrolling behaviour and the keyboard
/// handling identical on every screen of the flow.
class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({super.key, required this.child, this.title});

  final Widget child;

  /// When provided, an app bar with a back button is shown.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final appBarTitle = title;

    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      appBar: appBarTitle == null
          ? null
          : AppBar(
              backgroundColor: AppColors.darkBackgroundColor,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => Navigator.maybePop(context),
              ),
              title: Text(appBarTitle, style: AppStyles.bold16White),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
