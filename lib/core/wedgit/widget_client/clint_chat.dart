import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientChatPage extends StatefulWidget {
  final String orderId;

  const ClientChatPage({
    super.key,
    required this.orderId, required String userId,
  });

  @override
  State<ClientChatPage> createState() => _ClientChatPageState();
}

class _ClientChatPageState extends State<ClientChatPage> {
  final TextEditingController messageController = TextEditingController();
  String userName = 'عميل';

  CollectionReference get chatRef => FirebaseFirestore.instance
      .collection('chats')
      .doc(widget.orderId)
      .collection('messages');

  @override
  void initState() {
    super.initState();
    ensureChatExists();
  }

  Future<void> ensureChatExists() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    userName = userDoc.data()?['name'] ?? 'عميل';

    final chatDoc =
    FirebaseFirestore.instance.collection('chats').doc(widget.orderId);

    if (!(await chatDoc.get()).exists) {
      await chatDoc.set({
        'orderId': widget.orderId,
        'userId': uid,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
      });
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    await ensureChatExists();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await chatRef.add({
      'text': text,
      'senderId': uid,
      'senderName': userName,
      'senderType': 'client',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.orderId)
        .update({
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': text,
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'محادثة الدعم الفني',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatRef.orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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

                final messages = snapshot.data!.docs;

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
                          color: isMe ? Colors.blue : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['senderName'] ?? 'مستخدم',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              data['text'],
                              style: const TextStyle(color: Colors.white),
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
                    hintText: 'اكتب رسالتك...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
