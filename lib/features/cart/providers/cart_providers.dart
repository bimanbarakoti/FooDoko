// lib/features/cart/providers/cart_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Cart Item Model
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final String restaurantId;
  final String restaurantName;
  final Map<String, dynamic> customizations;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
    required this.restaurantId,
    required this.restaurantName,
    this.customizations = const {},
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? restaurantId,
    String? restaurantName,
    Map<String, dynamic>? customizations,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      customizations: customizations ?? this.customizations,
    );
  }

  double get totalPrice => price * quantity;
}

// Cart State Model
class CartState {
  final List<CartItem> items;
  final double deliveryFee;
  final double serviceFee;
  final double discount;

  const CartState({
    this.items = const [],
    this.deliveryFee = 2.99,
    this.serviceFee = 1.99,
    this.discount = 0.0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? deliveryFee,
    double? serviceFee,
    double? discount,
  }) {
    return CartState(
      items: items ?? this.items,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      discount: discount ?? this.discount,
    );
  }

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal + deliveryFee + serviceFee - discount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(CartItem item) {
    final existingIndex = state.items.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      // Update quantity if item exists
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + item.quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void clearCart() {
    state = const CartState();
  }

  void applyDiscount(double discountAmount) {
    state = state.copyWith(discount: discountAmount);
  }

  void updateDeliveryFee(double fee) {
    state = state.copyWith(deliveryFee: fee);
  }

  // Quick add popular items
  void addPopularItem(String type) {
    final popularItems = {
      'pizza': CartItem(
        id: 'pizza_margherita',
        name: 'Margherita Pizza',
        price: 18.99,
        imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        restaurantId: 'pizza_palace',
        restaurantName: 'Pizza Palace',
      ),
      'burger': CartItem(
        id: 'classic_burger',
        name: 'Classic Burger',
        price: 14.99,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        restaurantId: 'burger_junction',
        restaurantName: 'Burger Junction',
      ),
      'sushi': CartItem(
        id: 'salmon_roll',
        name: 'Salmon Roll',
        price: 22.99,
        imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        restaurantId: 'sakura_sushi',
        restaurantName: 'Sakura Sushi',
      ),
    };

    final item = popularItems[type];
    if (item != null) {
      addItem(item);
    }
  }
}

// Main Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Cart item count provider
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.itemCount;
});

// Cart total provider
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.total;
});

// Cart subtotal provider
final cartSubtotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.subtotal;
});

// Cart empty state provider
final cartEmptyProvider = Provider<bool>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.isEmpty;
});

// Delivery fee provider
final deliveryFeeProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.deliveryFee;
});

// Service fee provider
final serviceFeeProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.serviceFee;
});

// Discount provider
final discountProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.discount;
});