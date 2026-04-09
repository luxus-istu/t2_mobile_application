import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/tracking/data/datasources/tracking_local_data_source.dart';
import 'package:t2_mobile_application/features/tracking/domain/entities/poi_entity.dart';
import 'package:t2_mobile_application/features/tracking/domain/repositories/tracking_repository.dart';

@LazySingleton(as: TrackingRepository)
final class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingLocalDataSource localDataSource;

  const TrackingRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Exception, List<PoiEntity>>> getPois() async {
    return await localDataSource.getUdmurtiaPois();
  }

  @override
  Future<void> saveVisitedPoi(String id) async {
    await localDataSource.saveVisitedPoiId(id);
  }

  @override
  Future<List<String>> getVisitedPois() async {
    return await localDataSource.getVisitedPoiIds();
  }
}
