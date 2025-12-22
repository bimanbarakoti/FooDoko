import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ar_food_service.dart';

// AR State Management
class ARState {
  final bool isAREnabled;
  final Map<String, dynamic> current3DModel;
  final Map<String, dynamic> virtualTour;
  final List<Map<String, dynamic>> scannedItems;
  final Map<String, dynamic> tastingData;

  ARState({
    this.isAREnabled = false,
    this.current3DModel = const {},
    this.virtualTour = const {},
    this.scannedItems = const [],
    this.tastingData = const {},
  });

  ARState copyWith({
    bool? isAREnabled,
    Map<String, dynamic>? current3DModel,
    Map<String, dynamic>? virtualTour,
    List<Map<String, dynamic>>? scannedItems,
    Map<String, dynamic>? tastingData,
  }) {
    return ARState(
      isAREnabled: isAREnabled ?? this.isAREnabled,
      current3DModel: current3DModel ?? this.current3DModel,
      virtualTour: virtualTour ?? this.virtualTour,
      scannedItems: scannedItems ?? this.scannedItems,
      tastingData: tastingData ?? this.tastingData,
    );
  }
}

class ARNotifier extends StateNotifier<ARState> {
  ARNotifier() : super(ARState());

  void toggleAR() {
    state = state.copyWith(isAREnabled: !state.isAREnabled);
  }

  void load3DModel(String foodId) {
    final model = ARFoodService.visualizeFood3D(foodId);
    state = state.copyWith(current3DModel: model);
  }

  void startVirtualTour(String restaurantId) {
    final tour = ARFoodService.getVirtualTour(restaurantId);
    state = state.copyWith(virtualTour: tour);
  }
}

// Providers
final arProvider = StateNotifierProvider<ARNotifier, ARState>((ref) {
  return ARNotifier();
});

final food3DProvider = Provider.family<Map<String, dynamic>, String>((ref, foodId) {
  return ARFoodService.visualizeFood3D(foodId);
});

final virtualTourProvider = Provider.family<Map<String, dynamic>, String>((ref, restaurantId) {
  return ARFoodService.getVirtualTour(restaurantId);
});

final menuScanProvider = Provider.family<Map<String, dynamic>, String>((ref, imageData) {
  return ARFoodService.scanMenuWithAR(imageData);
});

final virtualTastingProvider = Provider.family<Map<String, dynamic>, String>((ref, dishId) {
  return ARFoodService.virtualTasting(dishId);
});