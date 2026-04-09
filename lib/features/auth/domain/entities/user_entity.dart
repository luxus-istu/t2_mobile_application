import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String phone;

  const UserEntity({required this.phone});

  @override
  List<Object?> get props => [phone];
}
