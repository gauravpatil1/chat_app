import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'message.dart';

class Chat extends Equatable {
  final List<Message> messages;
  final Timestamp createdAt;
  final List<String> participantsAvatarUrl;
  final List<String> participantsId;
  final List<String> participantsName;
  final String chatId;
  final String latestMessage;
  final Timestamp latestMessageTime;
  final bool isLatestMessageImage;
  final String latestMessageSenderId;
  final int unseenCount;

  const Chat({
    required this.messages,
    required this.createdAt,
    required this.participantsAvatarUrl,
    required this.participantsId,
    required this.participantsName,
    required this.chatId,
    required this.latestMessage,
    required this.latestMessageTime,
    required this.isLatestMessageImage,
    required this.latestMessageSenderId,
    required this.unseenCount,
  });

  @override
  List<Object> get props => [
        messages,
        createdAt,
        participantsAvatarUrl,
        participantsId,
        participantsName,
        chatId,
        latestMessage,
        latestMessageTime,
        isLatestMessageImage,
        latestMessageSenderId,
        unseenCount,
      ];
}
