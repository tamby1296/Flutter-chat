import 'package:demo7/widget/chat_messages.dart';
import 'package:demo7/widget/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setupPushNotif() async {

    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          IconButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatMessages()),
          NewMessage()
        ],
      ),
    );
  }
}