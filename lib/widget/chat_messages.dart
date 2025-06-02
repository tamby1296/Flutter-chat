import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo7/widget/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chat_messages')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages found.'));
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final loadedMessages = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final message = loadedMessages[index].data();
            final nextMessage =
                index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
            final userId = message['userId'];
            final nextUserId =
                nextMessage == null ? null : nextMessage['userId'];
            final nextUserSame = userId == nextUserId;

            if (nextUserSame) {
              return MessageBubble.next(
                message: message['text'],
                isMe: user!.uid == userId,
              );
            }

            return MessageBubble.first(
              userImage: null,
              username: message['username'],
              message: message['text'],
              isMe: user!.uid == userId,
            );
          },
        );
      },
    );
  }
}
