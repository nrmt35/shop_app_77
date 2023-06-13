import 'package:flutter/material.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData get light => _genLightTheme();

  static ThemeData get dark => _genDarkTheme();

  static ThemeData _genLightTheme() {
    const inputDecorationInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    );

    return ThemeData(
      // bool? applyElevationOverlayColor,
      // NoDefaultCupertinoThemeData? cupertinoOverrideTheme,
      // Iterable<ThemeExtension<dynamic>>? extensions,
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorMaxLines: 2,
        contentPadding: EdgeInsets.all(12),
        filled: true,
        fillColor: Colors.white,
        errorBorder: inputDecorationInputBorder,
        focusedBorder: inputDecorationInputBorder,
        focusedErrorBorder: inputDecorationInputBorder,
        disabledBorder: inputDecorationInputBorder,
        enabledBorder: inputDecorationInputBorder,
        border: inputDecorationInputBorder,
        alignLabelWithHint: true,
      ),
      // MaterialTapTargetSize? materialTapTargetSize,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // TargetPlatform? platform,
      // ScrollbarThemeData? scrollbarTheme,
      // InteractiveInkFeatureFactory? splashFactory,
      // bool? useMaterial3,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      ////
      // COLOR
      // [colorScheme] is the preferred way to configure colors. The other color
      // properties (as well as primaryColorBrightness, and primarySwatch)
      // will gradually be phased out, see https://github.com/flutter/flutter/issues/91772.
      ////

      // Color? backgroundColor,
      // Color? bottomAppBarColor,
      brightness: Brightness.light,
      // Color? canvasColor,
      cardColor: AppColors.white,
      // ColorScheme? colorScheme,
      // Color? colorSchemeSeed,
      // Color? dialogBackgroundColor,
      // Color? disabledColor,
      dividerColor: Colors.transparent,
      // Color? errorColor,
      // Color? focusColor,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      highlightColor: AppColors.primary.withOpacity(0.1),
      // Color? hintColor,
      // Color? hoverColor,
      // Color? indicatorColor,
      primaryColor: AppColors.primary,
      // Color? primaryColorDark,
      // Color? primaryColorLight,
      primarySwatch: AppColors.primarySwatch,
      scaffoldBackgroundColor: AppColors.white,
      // Color? secondaryHeaderColor,
      // Color? selectedRowColor,
      // Color? shadowColor,
      splashColor: AppColors.primary.withOpacity(0.1),
      // Color? toggleableActiveColor,
      // Color? unselectedWidgetColor,

      ////
      // TYPOGRAPHY & ICONOGRAPHY
      ////

      fontFamily: 'SF Pro Display',
      // IconThemeData? iconTheme,
      // IconThemeData? primaryIconTheme,
      textTheme: const TextTheme(
        titleSmall: TextStyle(
          color: AppColors.secondary,
        ),
        titleMedium: TextStyle(
          color: Colors.black,
        ),
      ),
      primaryIconTheme: const IconThemeData(
        color: Colors.black,
      ),
      // Typography? typography,

      ////
      // COMPONENT THEMES
      ////
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.black,
          size: 22,
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        scrolledUnderElevation: 0.25,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: AppColors.black,
          fontFamily: 'Inter',
        ),
      ),
      // MaterialBannerThemeData? bannerTheme,
      // BottomAppBarTheme? bottomAppBarTheme,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppColors.secondary,
        selectedItemColor: AppColors.primary,
      ),
      // BottomSheetThemeData? bottomSheetTheme,
      // ButtonBarThemeData? buttonBarTheme,
      // ButtonThemeData? buttonTheme,
      // CardTheme? cardTheme,
      // CheckboxThemeData? checkboxTheme,
      // ChipThemeData? chipTheme,
      // DataTableThemeData? dataTableTheme,
      // DialogTheme? dialogTheme,
      // DividerThemeData? dividerTheme,
      // DrawerThemeData? drawerTheme,
      // ElevatedButtonThemeData? elevatedButtonTheme,
      expansionTileTheme: const ExpansionTileThemeData(
        iconColor: Colors.black,
        collapsedIconColor: AppColors.secondary,
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        textColor: Colors.black,
        collapsedTextColor: AppColors.black,
      ),
      // FloatingActionButtonThemeData? floatingActionButtonTheme,
      // ListTileThemeData? listTileTheme,
      // NavigationBarThemeData? navigationBarTheme,
      // NavigationRailThemeData? navigationRailTheme,
      // OutlinedButtonThemeData? outlinedButtonTheme,
      // PopupMenuThemeData? popupMenuTheme,
      // ProgressIndicatorThemeData? progressIndicatorTheme,
      // RadioThemeData? radioTheme,
      // SliderThemeData? sliderTheme,
      // SnackBarThemeData? snackBarTheme,
      // SwitchThemeData? switchTheme,
      // TabBarTheme? tabBarTheme,
      // TextButtonThemeData? textButtonTheme,
      // TextSelectionThemeData? textSelectionTheme,
      // TimePickerThemeData? timePickerTheme,
      // ToggleButtonsThemeData? toggleButtonsTheme,
      // TooltipThemeData? tooltipTheme,
    );
  }

  static ThemeData _genDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Inter',
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    //use iOS like behavior without overscroll indicator
    return child;
  }

  static const ScrollPhysics _bouncingPhysics = BouncingScrollPhysics(
    parent: RangeMaintainingScrollPhysics(),
  );

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    //use iOS like bouncing physics
    return _bouncingPhysics;
  }
}

class AppColors {
  static const int _primaryColorValue = 0xff3364e0;

  static const MaterialColor primarySwatch = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xff8faaee),
      100: Color(0xff85a2ec),
      200: Color(0xff7093e9),
      300: Color(0xff5c83e6),
      400: Color(0xff4773e3),
      500: Color(_primaryColorValue),
      600: Color(0xff2e5aca),
      700: Color(0xff2950b3),
      800: Color(0xff24469d),
      900: Color(0xff1f3c86),
    },
  );

  static const Color primary = Color(0xff3364E0);
  static const Color secondary = Color(0xFFA5A9B2);
  static const Color lightGray = Color(0xFFF8F7F5);
  static const Color lightGray2 = Color(0xFFEFEEEC);


  static const Color black = Color(0xff000000);
  static const Color white = Colors.white;
}
