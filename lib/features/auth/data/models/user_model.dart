import 'package:hive_ce/hive_ce.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String phone;

  @HiveField(1)
  String password;

  UserModel({
    required this.phone,
    required this.password,
  });

  factory UserModel.fromEntity(UserEntity entity, String password) {
    return UserModel(
      phone: entity.phone,
      password: password,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      phone: phone,
    );
  }
}
