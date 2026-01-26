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

/// 🔹 Mobile only
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

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!Platform.isWindows) {
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  } else {
    debugPrint('Windows detected → FCM & AppCheck disabled');
  }

  final materialRepository =
  MaterialRepository(FirebaseFirestore.instance);

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

        /// Materia (الصفحه المخزن)
        BlocProvider<MaterialCubit>(
          create: (_) => MaterialCubit(materialRepository),
        ),

        /// Home (الصفحه الرئسيه)
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

  FlutterNativeSplash.remove();
}
