import 'package:flutter/material.dart';

import '../../generated/colors.gen.dart';

const mainColor = Color.fromARGB(255, 216, 65, 18); // foreground

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: ColorName.primary, // Màu chính từ ColorName
    onPrimary: Colors.white,
    primaryContainer: ColorName.materialPrimary[100] ??
        Colors.grey, // Giá trị mặc định nếu null
    onPrimaryContainer: Colors.black,
    primaryFixed: ColorName.materialPrimary[800], // Giá trị mặc định nếu null
    primaryFixedDim:
        ColorName.materialPrimary[400], // Giá trị mặc định nếu null
    onPrimaryFixed: Colors.white,
    onPrimaryFixedVariant: Colors.black,
    secondary: ColorName.secondary, // Màu thứ cấp
    onSecondary: Colors.black,
    secondaryContainer:
        ColorName.materialSecondary[100], // Giá trị mặc định nếu null
    onSecondaryContainer: Colors.black,
    secondaryFixed:
        ColorName.materialSecondary[800], // Giá trị mặc định nếu null
    secondaryFixedDim:
        ColorName.materialSecondary[400], // Giá trị mặc định nếu null
    onSecondaryFixed: Colors.white,
    onSecondaryFixedVariant: Colors.black,
    onErrorContainer: Colors.black,
    surface: ColorName.background, // Màu bề mặt
    onSurface: Colors.black,
    surfaceDim: ColorName.materialNeutral[300], // Giá trị mặc định nếu null
    surfaceBright: ColorName.materialNeutral[200], // Giá trị mặc định nếu null
    surfaceContainerLowest:
        ColorName.materialNeutral[50], // Giá trị mặc định nếu null
    surfaceContainerLow:
        ColorName.materialNeutral[100], // Giá trị mặc định nếu null
    surfaceContainer:
        ColorName.materialNeutral[400], // Giá trị mặc định nếu null
    surfaceContainerHigh:
        ColorName.materialNeutral[500], // Giá trị mặc định nếu null
    surfaceContainerHighest:
        ColorName.materialNeutral[600], // Giá trị mặc định nếu null
    onSurfaceVariant: Colors.black,
    outline: ColorName.materialNeutral[700], // Giá trị mặc định nếu null
    outlineVariant: Colors.grey,
    shadow: Colors.black54,
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: ColorName.backgroundDark, // Màu nền đảo ngược
    onInverseSurface: Colors.white,
    inversePrimary: ColorName.primary, // Màu chính đảo ngược
    surfaceTint: ColorName.primary, // Màu tông bề mặt
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
);
