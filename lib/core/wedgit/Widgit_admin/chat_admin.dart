import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminChatPage extends StatefulWidget {
  final String userId;

  const AdminChatPage({
    super.key,
    required this.userId,
  });

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  final TextEditingController messageController = TextEditingController();

  CollectionReference get chatRef => FirebaseFirestore.instance
      .collection('chats')
      .doc(widget.userId)
      .collection('messages');

  /// ===============================
  /// 🔵 Send Message (FINAL)
  /// ===============================
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final userData = userDoc.data()!;
    final senderName = userData['name'] ?? 'مستخدم';
    final senderRole = userData['role'] ?? 'eng';

    await chatRef.add({
      'text': text,
      'senderId': uid,
      'senderName': senderName,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.userId)
        .update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'محادثة العميل',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          /// ===============================
          /// 🔵 Messages
          /// ===============================
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatRef.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'لا توجد رسائل بعد',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12.w),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data =
                    messages[index].data() as Map<String, dynamic>;

                    final isMe = data['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid;

                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color:
                          isMe ? Colors.green : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['text'],
                              style: TextStyle(
                                color:
                                isMe ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),


          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'اكتب ردك...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
