import 'package:dartz/dartz.dart';
import 'package:t2_mobile_application/features/tracking/domain/entities/poi_entity.dart';

abstract interface class TrackingRepository {
  Future<Either<Exception, List<PoiEntity>>> getPois();
  Future<void> saveVisitedPoi(String id);
  Future<List<String>> getVisitedPois();
}
