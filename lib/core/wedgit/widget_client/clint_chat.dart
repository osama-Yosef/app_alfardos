import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClientChatPage extends StatefulWidget {
  final String userId;

  const ClientChatPage({super.key, required this.userId});

  @override
  State<ClientChatPage> createState() => _ClientChatPageState();
}

class _ClientChatPageState extends State<ClientChatPage> {
  final TextEditingController messageController = TextEditingController();
  String userName = 'عميل';

  CollectionReference get chatRef => FirebaseFirestore.instance
      .collection('chats')
      .doc(widget.userId)
      .collection('messages');

  @override
  void initState() {
    super.initState();
    ensureChatExists();
  }

  Future<void> ensureChatExists() async {
    final uid = widget.userId;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    userName = userDoc.data()?['name'] ?? 'عميل';

    final chatDoc = FirebaseFirestore.instance.collection('chats').doc(uid);

    if (!(await chatDoc.get()).exists) {
      await chatDoc.set({
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
    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final userRole = userDoc.data()?['role'] ?? 'client';

    await chatRef.add({
      'text': text,
      'senderId': currentUser.uid,
      'senderName': userName,
      'senderType': (userRole == 'client') ? 'client' : 'eng',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.userId)
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),

        title: Text(
          'محادثة الدعم الفني',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: chatRef.orderBy('createdAt').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('لا توجد رسائل بعد'));
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final data = messages[index].data() as Map<String, dynamic>;
                      final isMe =
                          data['senderId'] ==
                          FirebaseAuth.instance.currentUser!.uid;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['senderName'] ?? 'مستخدم',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(
                                data['text'],
                                style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w700),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
