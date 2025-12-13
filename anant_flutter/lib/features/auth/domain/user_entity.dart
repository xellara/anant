class UserEntity {
  final int id;
  final String username;
  final String? uid;

  UserEntity({
    required this.id, 
    required this.username,
    this.uid,
  });
}