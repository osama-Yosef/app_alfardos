import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/routing/app_router.dart';
import '../core/routing/routes.dart';
import '../core/theming/app_themng.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
    });
  }

  @override
  Widget build(BuildContext context) {
    Size designSize;
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      designSize = Size(1920, 1080);
    } else {
      designSize = Size(375, 812);
    }

    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Alfardos',
          onGenerateRoute: AppRouter.navigator,
          initialRoute: Routes.SplashScreen,
          theme: AppThemLightMode.lightTheme,
          locale: Locale('ar', 'eg'),
          supportedLocales: [Locale('ar', 'eg'), Locale('en', 'US')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            return Locale('ar', 'SA');
          },
        );
      },
    );
  }
}