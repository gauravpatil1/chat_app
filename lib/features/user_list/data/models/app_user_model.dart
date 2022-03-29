import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required String uid,
    required String name,
    required String email,
    required String photoUrl,
    required String status,
    required bool isOnline,
    required Timestamp lastSeen,
  }) : super(
          uid: uid,
          name: name,
          email: email,
          photoUrl: photoUrl,
          status: status,
          isOnline: isOnline,
          lastSeen: lastSeen,
        );

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      status: json['status'],
      isOnline: json['isOnline'],
      lastSeen: json['lastSeen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'status': status,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}
