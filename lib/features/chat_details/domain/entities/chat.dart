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

  const Chat({
    required this.messages,
    required this.createdAt,
    required this.participantsAvatarUrl,
    required this.participantsId,
    required this.participantsName,
    required this.chatId,
  });

  @override
  List<Object> get props => [
        messages,
        createdAt,
        participantsAvatarUrl,
        participantsId,
        participantsName,
        chatId,
      ];
}
