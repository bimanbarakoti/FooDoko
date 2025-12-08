// lib/features/tracking/providers/tracking_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_tracking_repository.dart';

final trackingRepoProvider = Provider<MockTrackingRepository>((ref) => MockTrackingRepository());

final trackingStreamProvider = StreamProvider<TrackingPoint>((ref) {
  final repo = ref.watch(trackingRepoProvider);
  return repo.simulateDriver();
});
