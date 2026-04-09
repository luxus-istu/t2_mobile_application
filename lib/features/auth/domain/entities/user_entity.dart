import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String phone;
  final String firstName;
  final String lastName;
  final String gender;

  const UserEntity({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  @override
  List<Object?> get props => [phone, firstName, lastName, gender];
}
