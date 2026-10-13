import 'package:flutter/material.dart';

import 'app_tokens.dart';
import 'app_semantic_colors.dart';

/// 앱 전체 테마. `MaterialApp(theme: AppTheme.light())`로 적용한다.
///
/// 키오스크는 실내 조명 아래 한 가지 화면으로만 운영하므로 v1은 라이트 테마만 둔다.
abstract final class AppTheme {
  static const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.navy,
    onTertiary: Colors.white,
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: AppColors.dangerContainer,
    onErrorContainer: Color(0xFF5F1412),
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    onSurfaceVariant: AppColors.textSecondary,
    surfaceContainerLowest: AppColors.surface,
    surfaceContainerLow: AppColors.background,
    surfaceContainer: AppColors.surfaceVariant,
    surfaceContainerHigh: AppColors.surfaceVariant,
    surfaceContainerHighest: AppColors.surfaceVariant,
    outline: AppColors.outlineStrong,
    outlineVariant: AppColors.outline,
    scrim: AppColors.scrim,
  );

  static ThemeData light() {
    final textTheme = AppTypography.textTheme;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    const buttonMinSize = Size(
      AppSize.touchTargetMin * 2,
      AppSize.buttonMedium,
    );
    const buttonPadding = EdgeInsets.symmetric(horizontal: AppSpacing.lg);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      extensions: const [AppSemanticColors.light],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 88,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: const IconThemeData(size: AppSize.iconMd),
      ),
      iconTheme: const IconThemeData(
        size: AppSize.iconMd,
        color: AppColors.textPrimary,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
          side: const BorderSide(color: AppColors.outline, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            AppSize.touchTargetMin,
            AppSize.touchTargetMin,
          ),
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: textTheme.labelMedium,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSize.touchTargetMin),
          iconSize: AppSize.iconMd,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shape: const StadiumBorder(),
        side: const BorderSide(color: AppColors.outline),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primary,
        showCheckmark: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textDisabled,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryContainer,
        linearMinHeight: 8,
      ),
    );
  }

  /// 관리 모드처럼 가까이서 조작하는 화면용 촘촘한 테마.
  ///
  /// 방문객 화면보다 글자를 한 단계 줄이고 입력창·칩 여백을 좁힌다.
  /// 누르는 요소는 최소 [AppSize.buttonSmall](48dp)를 지킨다.
  static ThemeData dense(ThemeData base) {
    final textTheme = base.textTheme.apply(fontSizeFactor: 0.8);
    return base.copyWith(
      textTheme: textTheme,
      visualDensity: VisualDensity.compact,
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textDisabled,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: base.textButtonTheme.style?.copyWith(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSize.buttonSmall, AppSize.buttonSmall),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        ),
      ),
    );
  }
}
