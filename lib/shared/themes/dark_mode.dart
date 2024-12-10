import 'package:flutter/material.dart';
import '../../generated/colors.gen.dart';

const mainColor = Color.fromARGB(255, 216, 65, 18); // foreground

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: ColorName.primary, // Màu chính từ ColorName
    onPrimary: Colors.black,
    primaryContainer:
        ColorName.materialPrimary[200] ?? Colors.grey, // Màu container chính
    onPrimaryContainer: Colors.black,
    secondary: ColorName.secondary, // Màu thứ cấp
    onSecondary: Colors.white,
    secondaryContainer: ColorName.materialSecondary[200] ??
        Colors.grey, // Màu container thứ cấp
    onSecondaryContainer: Colors.black,
    surface: ColorName.backgroundDark, // Màu bề mặt
    onSurface: Colors.white,
    surfaceDim: ColorName.materialNeutral[700], // Màu bề mặt tối
    surfaceBright: ColorName.materialNeutral[600], // Màu bề mặt sáng
    surfaceContainerLowest:
        ColorName.materialNeutral[900], // Màu container thấp nhất
    surfaceContainerLow: ColorName.materialNeutral[800], // Màu container thấp
    surfaceContainer: ColorName.materialNeutral[500], // Màu container
    surfaceContainerHigh: ColorName.materialNeutral[400], // Màu container cao
    surfaceContainerHighest:
        ColorName.materialNeutral[300], // Màu container cao nhất
    onSurfaceVariant: Colors.white,
    outline: ColorName.materialNeutral[500], // Màu viền
    shadow: Colors.black54,
    scrim: Colors.black.withOpacity(0.5),
    inverseSurface: ColorName.background, // Màu nền đảo ngược
    onInverseSurface: Colors.black,
    inversePrimary: ColorName.primary, // Màu chính đảo ngược
    surfaceTint: ColorName.primary, // Màu tông bề mặt
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
);
