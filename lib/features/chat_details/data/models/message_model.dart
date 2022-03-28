import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required String message,
    required String imageAsMessage,
    required Timestamp receivedAt,
    required Timestamp sentAt,
    required Timestamp seenAt,
    required String senderAvatarUrl,
    required String senderId,
    required String senderName,
  }) : super(
          message: message,
          imageAsMessage: imageAsMessage,
          receivedAt: receivedAt,
          sentAt: sentAt,
          seenAt: seenAt,
          senderAvatarUrl: senderAvatarUrl,
          senderId: senderId,
          senderName: senderName,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      imageAsMessage: json['imageAsMessage'],
      receivedAt: json['receivedAt'],
      sentAt: json['sentAt'],
      seenAt: json['seenAt'],
      senderAvatarUrl: json['senderAvatarUrl'],
      senderId: json['senderId'],
      senderName: json['senderName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'imageAsMessage': imageAsMessage,
      'receivedAt': receivedAt,
      'sentAt': sentAt,
      'seenAt': seenAt,
      'senderAvatarUrl': senderAvatarUrl,
      'senderId': senderId,
      'senderName': senderName,
    };
  }
}
