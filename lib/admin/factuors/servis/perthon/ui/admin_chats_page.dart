import 'package:app_alfardos/core/wedgit/Widgit_admin/eng_app_par.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/wedgit/Widgit_admin/chat_admin.dart';

class AdminChatsPage extends StatelessWidget {
  const AdminChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EngAppPar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'حدث خطأ أثناء تحميل المحادثات',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          /// 📭 Empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'لا يوجد محادثات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data =
                  chats[index].data() as Map<String, dynamic>? ?? {};

              final userName = data['userName'] ?? 'عميل';
              final lastMessage = data['lastMessage'] ?? '';
              final userId = data['userId'];

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(
                  userName.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  lastMessage.toString(),
                  style: const TextStyle(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: userId == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminChatPage(
                        userId: userId.toString(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
