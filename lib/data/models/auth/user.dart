import 'package:music/domain/entities/auth/user.dart';

class UserModel {
  String? fullName;
  String? email;
  String? imgUrl;

  UserModel({
    this.fullName,
    this.email,
    this.imgUrl,
  });

  UserModel.fromJson(Map<String, dynamic> data) {
    fullName = data['name'];
    email = data['email'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      fullName: fullName,
      imgUrl: imgUrl,
    );
  }
}
