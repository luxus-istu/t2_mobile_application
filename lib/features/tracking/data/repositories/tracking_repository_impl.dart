import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/tracking/data/datasources/tracking_local_data_source.dart';
import 'package:t2_mobile_application/features/tracking/data/datasources/tracking_remote_data_source.dart';
import 'package:t2_mobile_application/features/tracking/domain/entities/poi_entity.dart';
import 'package:t2_mobile_application/features/tracking/domain/repositories/tracking_repository.dart';

@LazySingleton(as: TrackingRepository)
final class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingLocalDataSource localDataSource;
  final TrackingRemoteDataSource remoteDataSource;

  const TrackingRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<Either<Exception, List<PoiEntity>>> getPois() async {
    return await localDataSource.getUdmurtiaPois();
  }

  @override
  Future<void> saveVisitedPoi(String id) async {
    await localDataSource.saveVisitedPoiId(id);
    await remoteDataSource.saveVisitedPoi(id);
  }

  @override
  Future<List<String>> getVisitedPois() async {
    final localPois = await localDataSource.getVisitedPoiIds();
    final remotePois = await remoteDataSource.getVisitedPois();
    final allPois = {...localPois, ...remotePois}.toList();
    
    // Sync missing to local
    for (var poi in remotePois) {
      if (!localPois.contains(poi)) {
        await localDataSource.saveVisitedPoiId(poi);
      }
    }
    
    // Sync missing to remote
    for (var poi in localPois) {
      if (!remotePois.contains(poi)) {
        await remoteDataSource.saveVisitedPoi(poi);
      }
    }
    
    return allPois;
  }
}
