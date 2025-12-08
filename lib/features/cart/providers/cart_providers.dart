import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cart_item.dart';
import 'package:foodoko/features/restaurant/data/models/menu_item_model.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(MenuItemModel menuItem) {
    final index = state.indexWhere((c) => c.item.id == menuItem.id);

    if (index == -1) {
      state = [...state, CartItem(item: menuItem)];
    } else {
      final updated = state[index].copyWith(
        quantity: state[index].quantity + 1,
      );

      state = [
        ...state.take(index),
        updated,
        ...state.skip(index + 1),
      ];
    }
  }

  void decreaseQuantity(CartItem cartItem) {
    final index = state.indexWhere((c) => c.item.id == cartItem.item.id);

    if (index == -1) return;

    final current = state[index];

    if (current.quantity == 1) {
      remove(cartItem);
    } else {
      final updated = current.copyWith(quantity: current.quantity - 1);

      state = [
        ...state.take(index),
        updated,
        ...state.skip(index + 1),
      ];
    }
  }

  void remove(CartItem cartItem) {
    state = state.where((c) => c.item.id != cartItem.item.id).toList();
  }
}

final cartProvider =
StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartItemsProvider = Provider<List<CartItem>>((ref) {
  return ref.watch(cartProvider);
});

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, c) => sum + c.totalPrice);
});
