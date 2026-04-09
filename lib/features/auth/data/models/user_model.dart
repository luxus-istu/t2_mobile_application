import 'package:hive_ce/hive_ce.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String phone;

  @HiveField(1)
  String password;

  @HiveField(2)
  String firstName;

  @HiveField(3)
  String lastName;

  @HiveField(4)
  String gender;

  UserModel({
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  factory UserModel.fromEntity(UserEntity entity, String password) {
    return UserModel(
      phone: entity.phone,
      password: password,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      phone: phone,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
  }
}
