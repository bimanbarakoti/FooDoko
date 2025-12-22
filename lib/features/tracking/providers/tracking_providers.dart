import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ultra_live_tracking.dart';

// Tracking State
class TrackingState {
  final Map<String, Map<String, dynamic>> activeOrders;
  final Map<String, dynamic> deliveryInsights;
  final Map<String, dynamic> predictiveAnalytics;
  final bool isTracking;

  TrackingState({
    this.activeOrders = const {},
    this.deliveryInsights = const {},
    this.predictiveAnalytics = const {},
    this.isTracking = false,
  });

  TrackingState copyWith({
    Map<String, Map<String, dynamic>>? activeOrders,
    Map<String, dynamic>? deliveryInsights,
    Map<String, dynamic>? predictiveAnalytics,
    bool? isTracking,
  }) {
    return TrackingState(
      activeOrders: activeOrders ?? this.activeOrders,
      deliveryInsights: deliveryInsights ?? this.deliveryInsights,
      predictiveAnalytics: predictiveAnalytics ?? this.predictiveAnalytics,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

class TrackingNotifier extends StateNotifier<TrackingState> {
  TrackingNotifier() : super(TrackingState());

  void startTracking(String orderId) {
    state = state.copyWith(isTracking: true);
    
    UltraLiveTracking.trackOrderLive(orderId).listen((update) {
      final updatedOrders = Map<String, Map<String, dynamic>>.from(state.activeOrders);
      updatedOrders[orderId] = update;
      
      state = state.copyWith(activeOrders: updatedOrders);
    });
  }

  void loadDeliveryInsights(String orderId) {
    final insights = UltraLiveTracking.getDeliveryInsights(orderId);
    state = state.copyWith(deliveryInsights: insights);
  }

  void loadPredictiveAnalytics() {
    final analytics = UltraLiveTracking.getPredictiveAnalytics();
    state = state.copyWith(predictiveAnalytics: analytics);
  }

  void stopTracking() {
    state = state.copyWith(isTracking: false, activeOrders: {});
  }
}

// Providers
final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  return TrackingNotifier();
});

final orderTrackingProvider = Provider.family<Stream<Map<String, dynamic>>, String>((ref, orderId) {
  return UltraLiveTracking.trackOrderLive(orderId);
});

final deliveryInsightsProvider = Provider.family<Map<String, dynamic>, String>((ref, orderId) {
  return UltraLiveTracking.getDeliveryInsights(orderId);
});

final predictiveAnalyticsProvider = Provider<Map<String, dynamic>>((ref) {
  return UltraLiveTracking.getPredictiveAnalytics();
});

final activeOrdersProvider = Provider<Map<String, Map<String, dynamic>>>((ref) {
  return ref.watch(trackingProvider).activeOrders;
});