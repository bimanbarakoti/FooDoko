// lib/features/cart/data/models/cart_item.dart
import 'package:foodoko/features/restaurant/data/models/menu_item_model.dart';

class CartItem {
  final MenuItemModel item;
  final int quantity;

  CartItem({
    required this.item,
    this.quantity = 1,
  });

  CartItem copyWith({MenuItemModel? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => item.price * quantity;
}
