import 'package:flutter/material.dart';
import 'package:love_days/utils/app_colors.dart';

extension AppTextX on BuildContext {
  AppText get appText => AppText(Theme.of(this).textTheme);
}

class AppText {
  final TextTheme _t;
  AppText(this._t);

  // Core semantic styles (use these everywhere for consistency).
  TextStyle get heading => _t.titleLarge!.copyWith(fontWeight: FontWeight.w700);
  TextStyle get subheading =>
      _t.titleMedium!.copyWith(fontWeight: FontWeight.w600);
  TextStyle get body => _t.bodyLarge!;
  TextStyle get bodyMuted => _t.bodyLarge!
      .copyWith(color: AppColors.textPrimary.withValues(alpha: 0.9));
  TextStyle get caption => _t.bodySmall!
      .copyWith(color: AppColors.textPrimary.withValues(alpha: 0.54));
  TextStyle get overline => _t.labelSmall!.copyWith(
        color: AppColors.textPrimary.withValues(alpha: 0.38),
        letterSpacing: 2,
        fontWeight: FontWeight.w700,
      );

  // UI-specific semantics.
  TextStyle get navLabel =>
      _t.labelMedium!.copyWith(letterSpacing: 0.2, fontWeight: FontWeight.w600);
  TextStyle get code => _t.labelLarge!.copyWith(
        color: AppColors.textPrimary.withValues(alpha: 0.6),
        fontWeight: FontWeight.w600,
      );
  TextStyle get badge => _t.labelSmall!.copyWith(fontWeight: FontWeight.w700);
  TextStyle get statLabel => _t.labelSmall!.copyWith(
        color: AppColors.textPrimary.withValues(alpha: 0.3),
        letterSpacing: 1,
        fontWeight: FontWeight.w700,
      );

  // Special, intentional one-offs.
  TextStyle get emoji =>
      _t.titleLarge!.copyWith(fontSize: 44, fontWeight: FontWeight.w400);

  TextStyle get counter => _t.titleLarge!.copyWith(
        fontSize: 96,
        fontWeight: FontWeight.w900,
        letterSpacing: -2,
        height: 0.95,
      );

  TextStyle get counterLabel => _t.labelMedium!.copyWith(
        color: AppColors.textPrimary.withValues(alpha: 0.4),
        letterSpacing: 4,
        fontWeight: FontWeight.w700,
      );
}
