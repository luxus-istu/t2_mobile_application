import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/tracking/domain/entities/poi_entity.dart';
import 'package:t2_mobile_application/features/tracking/domain/repositories/tracking_repository.dart';

@lazySingleton
final class TrackingCubit extends Cubit<void> {
  final TrackingRepository _repository;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<Position>? _positionStream;
  List<PoiEntity> _pois = [];
  Set<String> _notifiedPoiIds = {};

  bool _isTracking = false;

  TrackingCubit(this._repository) : super(null) {
    _initNotifications();
    _loadPois();
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings: initSettings);
  }

  Future<void> _loadPois() async {
    final visited = await _repository.getVisitedPois();
    _notifiedPoiIds = visited.toSet();
    
    final result = await _repository.getPois();
    result.fold(
      (error) => null, 
      (pois) => _pois = pois,
    );
  }

  List<PoiEntity> get visitedPois {
    return _pois.where((poi) => _notifiedPoiIds.contains(poi.id)).toList();
  }

  List<PoiEntity> get allPois => _pois;

  void updateTrackingState({
    required bool geolocationEnabled,
    required bool notificationsEnabled,
  }) {
    final shouldTrack = geolocationEnabled && notificationsEnabled;

    if (shouldTrack && !_isTracking) {
      _startTracking();
    } else if (!shouldTrack && _isTracking) {
      _stopTracking();
    }
  }

  void _startTracking() async {
    _isTracking = true;

    // Check immediately upon starting
    try {
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      print(
        "Initial Position: ${initialPosition.latitude}, ${initialPosition.longitude}",
      );
      _checkNearbyPois(initialPosition);
    } catch (e) {
      print("Failed to get initial position: $e");
    }

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Only trigger if walked 10 meters
          ),
        ).listen((Position position) {
          print(
            "Stream Position Update: ${position.latitude}, ${position.longitude}",
          );
          _checkNearbyPois(position);
        });
  }

  void _stopTracking() {
    _isTracking = false;
    _positionStream?.cancel();
    _positionStream = null;
  }

  void _checkNearbyPois(Position currentPosition) {
    for (final poi in _pois) {
      if (_notifiedPoiIds.contains(poi.id)) continue;

      final distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        poi.latitude,
        poi.longitude,
      );

      print("Distance to ${poi.title}: $distanceInMeters meters");

      // Trigger if within 100 meters
      if (distanceInMeters <= 100) {
        print("TRIGGER ${poi.title}!");
        _triggerNotification(poi);
        _notifiedPoiIds.add(poi.id);
        _repository.saveVisitedPoi(poi.id);
      }
    }
  }

  Future<void> _triggerNotification(PoiEntity poi) async {
    const androidDetails = AndroidNotificationDetails(
      't2_places_channel',
      'T2 Interesting Places',
      channelDescription: 'Offline triggers for points of interest',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: poi.id.hashCode,
      title: poi.title,
      body: poi.description,
      notificationDetails: notificationDetails,
    );
  }

  @override
  Future<void> close() {
    _positionStream?.cancel();
    return super.close();
  }
}
