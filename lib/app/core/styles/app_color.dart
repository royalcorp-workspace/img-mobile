import 'package:flutter/material.dart';

class AppColors {
  // -- Main Colors --
  // static const primaryColor = Color(0xFFF0B010);
  // static const secondaryColor = Color(0xFFFF6B00);
  static const primaryColor = Color(0xFFB7975E);
  static const secondaryColor = Color(0xFFCAA96F);

// gold
  static const mainGold = Color(0xFFB7975E);
  static const lightGold = Color(0xFFCAA96F);
  static const creamGold = Color(0xFFE4CE9E);
  static const warmIvory = Color(0xFFF3EAE2);
  static const beige = Color(0xFFD1B68E);
  static const darkBrown = Color(0xFF271B0F);
  static const brownAccent = Color(0xFF9F6E53);

  static const green = Color(0xFF03C96A);
  static const blue = Color(0xFF0000FF);
  static const greenContrast = Color.fromARGB(255, 3, 172, 65);
  static const white = Color(0xFFFFFFFF);
  static const white12 = Color(0xFFF9F9FE);
  static const black = Color(0xFF000000);
  static const blackSecondary = Color(0xFF7E7E7E);
  static const orange = Color(0xFFF06400);
  static const grey = Color(0xFF9A9A9A);
  static const textDark = Color(0xFF222222);
  static const textMedium = Color(0xFF666666);
  static const textLight = Color(0xFF888888);
  static const disable = Color(0xFFABABAB);
  static const lightGrey = Color(0xFFdddddd);
  static const darkGrey = Color(0xFF808080);
  static const shadowGrey = Color(0xFFF1F3F3);
  static const greyWhite = Color(0xFFF5F5F5);
  static const red = Color(0xFFD32F2F);
  static const redContrast = Color(0xFFD72020);
  static const shadeRed = Color(0xFFFFEFEF);
  static const transparent = Colors.transparent;
  static const yellow = Color(0xFFFFCE3A);
  static const authBgMid = Color(0xFFF6B915);
  static const authBgBottom = Color(0xFFE08F0B);
}

class Gradients {
  /// Deep navy header gradient — primary brand gradient
  static LinearGradient primary() {
    return const LinearGradient(
      colors: [
        Color(0xFFB7975E),
        Color(0xFF9F6E53),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Warm gold gradient — for CTA buttons and accent surfaces
  static LinearGradient gold() {
    return const LinearGradient(
      colors: [Color(0xFFC8922A), Color(0xFFF0C04A)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  /// Subtle navy for cards / status surfaces
  static LinearGradient primaryAccent() {
    return const LinearGradient(
      colors: [Color(0xFF2D3580), Color(0xFF3D4270)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Neutral grey gradient for shimmer backgrounds
  static LinearGradient neutral() {
    return const LinearGradient(
      colors: [Color(0xFFE5E7EB), Color(0xFFF9FAFB)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Auth screen background — vertical gold wave, matches img_bg_auth.png
  static LinearGradient authBackground() {
    return const LinearGradient(
      colors: [
        AppColors.yellow,
        AppColors.authBgMid,
        AppColors.authBgMid,
        AppColors.authBgBottom,
      ],
      stops: [0.0, 0.45, 0.65, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Glass overlay color (use with BackdropFilter)
  static Color get glassOverlay => Colors.white.withOpacity(0.12);
}
