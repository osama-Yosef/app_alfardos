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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
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

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final data = chats[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(data['userName'] ?? 'عميل',style: TextStyle(color: Colors.white),),
                subtitle: Text(
                  data['lastMessage'] ?? '',style: TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,),
                trailing: const Icon(Icons.chat),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminChatPage(
                        orderId: data['orderId'],
                        userId: data['userId'],
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
