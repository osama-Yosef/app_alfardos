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
import 'admin/factuors/setting/perthon/cubit/pricing_cubit.dart';
import 'app_alfardos/my_app.dart';
import 'auth/data/repo/auth_repo_impl.dart';
import 'auth/perthon/cubit/auth_cubit.dart';
import 'client/factuors/client_order/perthon/cubit/order_cubit.dart';
import 'client/factuors/home_screen/perthon/cuibt/client_balance_cubit.dart';
import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await ScreenUtil.ensureScreenSize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );


  if (!Platform.isWindows) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  } else {
    print(" Firebase App Check disabled on Windows");
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthRepoImpl()),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(),
        ),
        BlocProvider<EngOrderCubit>(
          create: (_) => EngOrderCubit(),
        ),
        BlocProvider<SettingCubit>(
          create: (_) =>
          SettingCubit(FirebaseFirestore.instance)..listenToOrders(),
        ),
        BlocProvider(
          create: (_) => ClientBalanceCubit(),
        ),

      ],
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}
