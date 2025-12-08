import '../../home/data/models/dish_model.dart';

class MockCartRepository {
  final List<DishModel> _cartItems = [];

  List<DishModel> get cartItems => _cartItems;

  void addItem(DishModel item) {
    _cartItems.add(item);
  }

  void removeItem(DishModel item) {
    _cartItems.remove(item);
  }

  double get total {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void clear() {
    _cartItems.clear();
  }
}
