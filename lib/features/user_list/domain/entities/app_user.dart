import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String status;
  final bool isOnline;
  final Timestamp lastSeen;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.status,
    required this.isOnline,
    required this.lastSeen,
  });

  @override
  List<Object> get props => [
        uid,
        name,
        email,
        photoUrl,
        status,
        isOnline,
        lastSeen,
      ];
}
