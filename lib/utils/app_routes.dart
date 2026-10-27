class AppRoutes {
  static const String homeRouteName = "home_screen";
  static const String onBoardingRouteName = "onBoarding_tabs";

  /// Authentication screens pushed on top of the `AuthGate`.

  /// Account creation screen.
  static const String registerRouteName = "register_screen";

  /// Password reset request screen (the existing "forget password" UI).
  static const String forgotPasswordRouteName = "reset_password_screen";

  /// Screen that sets a new password from a Firebase reset link (`oobCode`).
  static const String newPasswordRouteName = "new_password_screen";

  /// Profile screen of the signed-in user.
  static const String updateProfileRouteName = "update_profile_screen";

  /// Movie details screen.
  static const String movieDetailsRouteName = "movie_details_screen";
}
