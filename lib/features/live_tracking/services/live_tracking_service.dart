// lib/features/live_tracking/services/live_tracking_service.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class LiveTrackingService {
  static final Map<String, StreamController<Map<String, dynamic>>> _orderStreams = {};
  static final Map<String, Map<String, dynamic>> _activeOrders = {};

  // Start real-time order tracking
  static Stream<Map<String, dynamic>> trackOrder(String orderId) {
    if (!_orderStreams.containsKey(orderId)) {
      _orderStreams[orderId] = StreamController<Map<String, dynamic>>.broadcast();
      _startOrderSimulation(orderId);
    }
    return _orderStreams[orderId]!.stream;
  }

  // Simulate real-time order progress
  static void _startOrderSimulation(String orderId) {
    final stages = [
      {'status': 'confirmed', 'message': 'Order confirmed by restaurant', 'progress': 0.1},
      {'status': 'preparing', 'message': 'Chef is preparing your food', 'progress': 0.3},
      {'status': 'ready', 'message': 'Food is ready for pickup', 'progress': 0.6},
      {'status': 'picked_up', 'message': 'Driver picked up your order', 'progress': 0.8},
      {'status': 'on_the_way', 'message': 'Driver is on the way', 'progress': 0.9},
      {'status': 'delivered', 'message': 'Order delivered successfully!', 'progress': 1.0},
    ];

    int currentStage = 0;
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (currentStage >= stages.length) {
        timer.cancel();
        _orderStreams[orderId]?.close();
        _orderStreams.remove(orderId);
        return;
      }

      final stage = stages[currentStage];
      final orderUpdate = {
        'orderId': orderId,
        'status': stage['status'],
        'message': stage['message'],
        'progress': stage['progress'],
        'timestamp': DateTime.now().toIso8601String(),
        'estimatedTime': _calculateRemainingTime(currentStage, stages.length),
        'driverLocation': _generateDriverLocation(),
        'driverInfo': _getDriverInfo(),
      };

      _activeOrders[orderId] = orderUpdate;
      _orderStreams[orderId]?.add(orderUpdate);
      
      if (kDebugMode) {
        print('📍 Order $orderId: ${stage['message']}');
      }

      currentStage++;
    });
  }

  // Generate realistic driver location updates
  static Map<String, double> _generateDriverLocation() {
    final random = Random();
    return {
      'latitude': 27.7172 + (random.nextDouble() - 0.5) * 0.01,
      'longitude': 85.3240 + (random.nextDouble() - 0.5) * 0.01,
    };
  }

  // Get driver information
  static Map<String, dynamic> _getDriverInfo() {
    final drivers = [
      {'name': 'Rajesh Kumar', 'rating': 4.8, 'phone': '+977-9841234567', 'vehicle': 'Motorcycle'},
      {'name': 'Sita Sharma', 'rating': 4.9, 'phone': '+977-9851234567', 'vehicle': 'Scooter'},
      {'name': 'Ram Bahadur', 'rating': 4.7, 'phone': '+977-9861234567', 'vehicle': 'Bicycle'},
    ];
    return drivers[Random().nextInt(drivers.length)];
  }

  // Calculate remaining delivery time
  static int _calculateRemainingTime(int currentStage, int totalStages) {
    final remainingStages = totalStages - currentStage;
    return remainingStages * 5; // 5 minutes per stage
  }

  // Get current order status
  static Map<String, dynamic>? getCurrentOrderStatus(String orderId) {
    return _activeOrders[orderId];
  }

  // Cancel order tracking
  static void cancelTracking(String orderId) {
    _orderStreams[orderId]?.close();
    _orderStreams.remove(orderId);
    _activeOrders.remove(orderId);
  }

  // Get all active orders
  static List<Map<String, dynamic>> getActiveOrders() {
    return _activeOrders.values.toList();
  }

  // Simulate driver chat
  static Stream<Map<String, dynamic>> getDriverChat(String orderId) {
    return Stream.periodic(const Duration(minutes: 2), (index) {
      final messages = [
        'Hi! I have picked up your order from the restaurant.',
        'I am on my way to your location.',
        'Traffic is light, will reach in 5 minutes.',
        'I am near your building. Please come down.',
      ];
      
      if (index < messages.length) {
        return {
          'message': messages[index],
          'timestamp': DateTime.now().toIso8601String(),
          'sender': 'driver',
        };
      }
      return null;
    }).where((message) => message != null).cast<Map<String, dynamic>>();
  }
}