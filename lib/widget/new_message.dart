import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final message = _messageController.text;
    if(message.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    // store to firestore
    await FirebaseFirestore.instance.collection('chat_messages').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: 15, right: 1, bottom: 14), child: Row(
      children: [
        Expanded(child: TextField(
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          enableSuggestions: true,
          decoration: InputDecoration(labelText: 'Send message...'),
          controller: _messageController,
        )),
        IconButton(onPressed: submitMessage, icon: Icon(Icons.send)),

      ],
    ),);
  }
}