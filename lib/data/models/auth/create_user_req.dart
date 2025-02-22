class CreateUserReq {
  String? userId;
  final String fullName;
  final String email;
  final String password;

  CreateUserReq({
    this.userId,
    required this.fullName,
    required this.email,
    required this.password,
  });
}
