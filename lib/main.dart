import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'admin/factuors/eng_screen/perthon/cubit/eng_cubit.dart';
import 'admin/factuors/factor/perthon/cuibt/factor_cubit.dart';
import 'admin/factuors/home_screen/perthon/cubit/home_cubit.dart';
import 'admin/factuors/live_production_follow_up/data/repo/repo.dart';
import 'admin/factuors/live_production_follow_up/perthon/cubit/material_cubit.dart';
import 'admin/factuors/setting/perthon/cubit/pricing_cubit.dart';
import 'app_alfardos/my_app.dart';
import 'auth/data/repo/auth_repo_impl.dart';
import 'auth/perthon/cubit/auth_cubit.dart';
import 'client/factuors/client_order/perthon/cubit/order_cubit.dart';
import 'client/factuors/home_screen/perthon/cuibt/client_balance_cubit.dart';
import 'firebase_options.dart';

/// 🔹 Background message handler — Mobile only
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    debugPrint(details.exceptionAsString());
  };

  // Splash screen — لا تُظهر على Windows لأن FlutterNativeSplash لا يدعمه
  if (!Platform.isWindows) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  // ── Firebase Init ──────────────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── Mobile / iOS only services ────────────────────────────────────────────
  if (Platform.isAndroid || Platform.isIOS) {
    // FCM background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request notification permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // App Check — Android: Play Integrity | iOS: App Attest
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  } else if (Platform.isWindows) {
    // ── Windows: تجاهل FCM و AppCheck ──────────────────────────────────────
    // firebase_messaging و AppCheck غير مدعومَين على Windows
    // Firebase Auth + Firestore يعملان بشكل طبيعي
    debugPrint('[Windows] FCM & AppCheck disabled — Firebase core active');
  }

  final materialRepository = MaterialRepository(FirebaseFirestore.instance);

  runApp(
    MultiBlocProvider(
      providers: [
        /// AUTH
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthRepoImpl()),
        ),

        /// CLIENT
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(),
        ),
        BlocProvider<ClientBalanceCubit>(
          create: (_) => ClientBalanceCubit(),
        ),

        /// ENGINEER
        BlocProvider<EngOrderCubit>(
          create: (_) => EngOrderCubit(),
        ),

        /// ADMIN - SETTING
        BlocProvider<SettingCubit>(
          create: (_) => SettingCubit(FirebaseFirestore.instance),
        ),

        /// FACTOR (التنفيذ)
        BlocProvider<ImplementCubit>(
          create: (_) => ImplementCubit(FirebaseFirestore.instance),
        ),

        /// Material (صفحة المخزن)
        BlocProvider<MaterialCubit>(
          create: (_) => MaterialCubit(materialRepository),
        ),

        /// Home (الصفحة الرئيسية)
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(FirebaseFirestore.instance),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (_, child) => child!,
        child: const MyApp(),
      ),
    ),
  );

  // إزالة Splash بعد تشغيل التطبيق
  if (!Platform.isWindows) {
    FlutterNativeSplash.remove();
  }
}
