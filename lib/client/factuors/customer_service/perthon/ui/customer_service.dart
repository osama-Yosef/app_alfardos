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
          builder: (_) => ClientChatPage(
            orderId: doc.id,
            userId: userId,
          ),
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
      appBar: const CustomClientAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 20.h,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800.w,maxHeight: 1000.h),
              child: Column(
                children: [
                  Text(
                    "خدمه العملاء",
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 24.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.support_agent,
                          size: 46.sp,
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

                        SizedBox(height: 50.h),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => openChat(context),
                            icon: Icon(
                              Icons.chat_bubble_rounded,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                            label: Text(
                              'ابدأ المحادثة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4CAF50),
                              elevation: 6,
                              shadowColor: Colors.black45,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 14.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 80.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _contactBtn(
                              FontAwesomeIcons.whatsapp,
                              Colors.green,
                              _launchWhatsApp,
                            ),
                            _contactBtn(
                              Icons.phone,
                              Colors.blue,
                              _launchCall,
                            ),
                            _contactBtn(
                              Icons.email,
                              Colors.red,
                              _launchEmail,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactBtn(
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(50.r),
      onTap: onTap,
      child: CircleAvatar(
        radius: 26.r,
        backgroundColor: color,
        child: Icon(
          icon,
          color: Colors.white,
          size: 22.sp,
        ),
      ),
    );
  }
}
