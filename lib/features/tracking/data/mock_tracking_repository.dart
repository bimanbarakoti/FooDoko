// lib/features/tracking/data/mock_tracking_repository.dart
import 'dart:async';
import 'dart:math';

class TrackingPoint {
  final double lat;
  final double lng;
  final DateTime ts;
  TrackingPoint(this.lat, this.lng): ts = DateTime.now();
}

class MockTrackingRepository {
  // Simulates driver moving from point A to B
  Stream<TrackingPoint> simulateDriver() async* {
    final rnd = Random();
    double lat = 27.7, lng = 85.33;
    for (int i = 0; i < 40; i++) {
      await Future.delayed(const Duration(seconds: 1));
      lat += (rnd.nextDouble() - 0.5) * 0.0015;
      lng += (rnd.nextDouble() - 0.5) * 0.0015;
      yield TrackingPoint(lat, lng);
    }
  }
}
