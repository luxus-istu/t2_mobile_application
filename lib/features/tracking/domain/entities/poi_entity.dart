import 'package:equatable/equatable.dart';

class PoiEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  const PoiEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [id, title, description, latitude, longitude];
}
