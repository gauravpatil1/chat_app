import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required String uid,
    required String name,
    required String email,
    required String photoUrl,
    required String status,
  }) : super(
          uid: uid,
          name: name,
          email: email,
          photoUrl: photoUrl,
          status: status,
        );

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'status': status,
    };
  }
}
