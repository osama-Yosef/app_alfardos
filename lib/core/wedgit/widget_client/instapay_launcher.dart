import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

Future<void> openInstaPay() async {
  final Uri webUrl =
  Uri.parse('https://ipn.eg/S/el-tip123/instapay/3UeDET');

  final Uri androidIntent = Uri.parse(
    'intent://ipn.eg/S/el-tip123/instapay/3UeDET'
        '#Intent;scheme=https;package=com.egyptianbanks.instapay;end',
  );

  try {
    if (Platform.isAndroid) {
      if (await canLaunchUrl(androidIntent)) {
        await launchUrl(
          androidIntent,
          mode: LaunchMode.externalApplication,
        );
        return;
      }
    }

    if (await canLaunchUrl(webUrl)) {
      await launchUrl(
        webUrl,
        mode: LaunchMode.externalApplication,
      );
      return;
    }

    throw 'InstaPay غير مثبت على الجهاز';
  } catch (e) {
    final Uri playStore = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.egyptianbanks.instapay',
    );

    await launchUrl(
      playStore,
      mode: LaunchMode.externalApplication,
    );
  }
}
