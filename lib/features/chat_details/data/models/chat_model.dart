import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'message_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required List<Message> messages,
    required Timestamp createdAt,
    required List<String> participantsAvatarUrl,
    required List<String> participantsId,
    required List<String> participantsName,
    required String chatId,
  }) : super(
          messages: messages,
          createdAt: createdAt,
          participantsAvatarUrl: participantsAvatarUrl,
          participantsId: participantsId,
          participantsName: participantsName,
          chatId: chatId,
        );

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      messages: (json['messages'] as List<dynamic>)
          .map((item) => item as MessageModel)
          .toList(),
      createdAt: json['createdAt'],
      participantsAvatarUrl: (json['participantsAvatarUrl'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      participantsId: (json['participantsId'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      participantsName: (json['participantsName'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
      chatId: json['chatId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages
          .map(
            (message) => jsonEncode((message as MessageModel).toJson()),
          )
          .toList(),
      'createdAt': createdAt,
      'participantsAvatarUrl': participantsAvatarUrl,
      'participantsId': participantsId,
      'participantsName': participantsName,
      'chatId': chatId,
    };
  }
}
