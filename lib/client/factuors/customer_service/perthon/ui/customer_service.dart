import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/wedgit/widget_client/clint_chat.dart';
import '../../../../../core/wedgit/widget_client/custom_client_app_bar.dart';

class ClientServicePage extends StatefulWidget {
  const ClientServicePage({super.key});

  @override
  State<ClientServicePage> createState() => _ClientServicePageState();
}

class _ClientServicePageState extends State<ClientServicePage> {
  Future<void> openChat(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final query = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClientChatPage(orderId: doc.id, userId: userId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد طلبات لهذا الحساب')),
      );
    }
  }

  Future<void> _launchWhatsApp() async {
    await launchUrl(
      Uri.parse("https://wa.me/201090017702"),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _launchCall() async {
    await launchUrl(Uri(scheme: 'tel', path: '01090017702'));
  }

  Future<void> _launchEmail() async {
    await launchUrl(
      Uri(
        scheme: 'mailto',
        path: 'alfardos26@gmail.com',
        query: 'subject=دعم فني',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomClientAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "خدمه العملاء",
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 35.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 48.sp,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'الدعم عبر المحادثة',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => openChat(context),
                      icon: const Icon(Icons.chat),
                      label:  Text(
                        'ابدأ المحادثة',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 200.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _contactBtn(
                  FontAwesomeIcons.whatsapp,
                  Colors.green,
                  _launchWhatsApp,
                ),
                _contactBtn(Icons.phone, Colors.blue, _launchCall),
                _contactBtn(Icons.email, Colors.red, _launchEmail),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactBtn(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 28.r,
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
