import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String gender;

  const UserEntity({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });

  @override
  List<Object?> get props => [email, firstName, lastName, gender];
}
