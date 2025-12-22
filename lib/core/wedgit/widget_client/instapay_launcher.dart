import 'package:url_launcher/url_launcher.dart';

Future<void> openInstaPay() async {
  final Uri uri = Uri.parse('https://ipn.eg/S/el-tip123/instapay/3UeDET');

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'InstaPay غير مثبت على الجهاز';
  }
}
