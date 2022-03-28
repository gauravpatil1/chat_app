import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String status;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.status,
  });

  @override
  List<Object> get props => [
        uid,
        name,
        email,
        photoUrl,
        status,
      ];
}
