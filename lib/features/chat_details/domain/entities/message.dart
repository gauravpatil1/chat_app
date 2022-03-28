import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String message;
  final String imageAsMessage;
  final Timestamp receivedAt;
  final Timestamp sentAt;
  final Timestamp seenAt;
  final String senderAvatarUrl;
  final String senderId;
  final String senderName;

  const Message({
    required this.message,
    required this.imageAsMessage,
    required this.receivedAt,
    required this.sentAt,
    required this.seenAt,
    required this.senderAvatarUrl,
    required this.senderId,
    required this.senderName,
  });

  @override
  List<Object> get props => [
        message,
        imageAsMessage,
        receivedAt,
        sentAt,
        seenAt,
        senderAvatarUrl,
        senderId,
        senderName,
      ];
}
