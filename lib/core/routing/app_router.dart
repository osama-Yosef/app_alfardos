


import 'package:app_alfardos/client/factuors/home_screen/perthon/ui/client_home_screen.dart';
import 'package:app_alfardos/core/routing/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../admin/factuors/customer_requests/perthon/ui/customer_requests.dart';
import '../../admin/factuors/eng_screen/perthon/ui/eng_screen.dart';
import '../../admin/factuors/factor/perthon/ui/factor.dart';
import '../../admin/factuors/home_screen/perthon/ui/home_screen.dart';
import '../../admin/factuors/live_production_follow_up/perthon/ui/live_production_follow_up.dart';
import '../../admin/factuors/servis/perthon/ui/admin_chats_page.dart';
import '../../admin/factuors/setting/perthon/ui/setting.dart';
import '../../app_alfardos/splash_screen/splash_screen.dart';
import '../../auth/perthon/login/ui/login_screen.dart';
import '../../auth/perthon/register/ui/register_screen.dart';
import '../../client/factuors/client_order/perthon/ui/client_order.dart';
import '../../client/factuors/client_show_order/perthon/ui/client_show_order.dart';
import '../../client/factuors/customer_service/perthon/ui/customer_service.dart';
import '../wedgit/Widgit_admin/select_matrial.dart';
import '../wedgit/wedgit_app/verify_email_screen.dart';

class AppRouter {
  static Route? navigator(RouteSettings setting) {
    switch (setting.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case Routes.registerScreen:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case Routes.customerRequests:
        return MaterialPageRoute(builder: (context) => CustomerRequests());
      case Routes.liveProductionFollowUp:
        return MaterialPageRoute(builder: (context) => LiveProductionFollowUp());
      case Routes.Setting:
        return MaterialPageRoute(builder: (context) => Setting());
      case Routes.SplashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case Routes.SelectMatrial:
        return MaterialPageRoute(
          builder: (context) => SelectMatrial(onAdd: (MaterialItem) {}),
        );
      case Routes.ClientHomeScreen:
        return MaterialPageRoute(builder: (context) => ClientHomeScreen());
      case Routes.ClientOrder:
        return MaterialPageRoute(builder: (context) => ClientOrder());
      case Routes.ClientShowOrder:
        return MaterialPageRoute(builder: (context) => ClientShowOrderPage());
      case Routes.verifyEmailScreen:
        return MaterialPageRoute(builder: (context) => VerifyEmailScreen());
      case Routes.ClientServicePage:
        return MaterialPageRoute(builder: (context) => ClientServicePage());
      case Routes.EngScreen:
        return MaterialPageRoute(builder: (context) => EngScreen());
      case Routes.AdminChatsPage:
        return MaterialPageRoute(builder: (context) => FactorPage());
      case Routes.Factor:
        return MaterialPageRoute(builder: (context) => AdminChatsPage());
      default:
        return MaterialPageRoute(builder: (context) => SizedBox());
    }
  }
}







