// lib/features/restaurant/data/mock_restaurant_repository.dart
import 'dart:async';
import 'models/menu_section_model.dart';
import 'models/menu_item_model.dart';

class MockRestaurantRepository {
  Future<List<MenuSectionModel>> fetchSections(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final sectionMap = {
      'r1': [ // Pizza Palace
        MenuSectionModel(id: 's1', title: 'Signature Pizzas', itemIds: ['i1','i2','i3']),
        MenuSectionModel(id: 's2', title: 'Pasta & Risotto', itemIds: ['i4','i5']),
        MenuSectionModel(id: 's3', title: 'Appetizers', itemIds: ['i6','i7']),
      ],
      'r2': [ // Burger Junction
        MenuSectionModel(id: 's1', title: 'Gourmet Burgers', itemIds: ['i1','i2','i3']),
        MenuSectionModel(id: 's2', title: 'Chicken & Fish', itemIds: ['i4','i5']),
        MenuSectionModel(id: 's3', title: 'Sides & Fries', itemIds: ['i6','i7']),
      ],
      'r3': [ // Sakura Sushi
        MenuSectionModel(id: 's1', title: 'Sushi & Sashimi', itemIds: ['i1','i2','i3']),
        MenuSectionModel(id: 's2', title: 'Hot Dishes', itemIds: ['i4','i5']),
        MenuSectionModel(id: 's3', title: 'Bento Boxes', itemIds: ['i6','i7']),
      ],
    };
    
    return sectionMap[restaurantId] ?? [
      MenuSectionModel(id: 's1', title: 'Popular Items', itemIds: ['i1','i2']),
      MenuSectionModel(id: 's2', title: 'House Specials', itemIds: ['i3','i4']),
    ];
  }

  Future<List<MenuItemModel>> fetchItems(String restaurantId) async {
    await Future.delayed(const Duration(milliseconds: 450));
    
    final itemMap = {
      'r1': [ // Pizza Palace
        MenuItemModel(id: 'i1', name: 'Margherita Classic', description: 'San Marzano tomatoes, fresh mozzarella, basil', price: 14.99, imageUrl: 'https://picsum.photos/300/200?margherita'),
        MenuItemModel(id: 'i2', name: 'Quattro Stagioni', description: 'Four seasons pizza with artichokes, ham, mushrooms', price: 18.99, imageUrl: 'https://picsum.photos/300/200?quattro'),
        MenuItemModel(id: 'i3', name: 'Diavola Spicy', description: 'Spicy salami, chili flakes, mozzarella', price: 16.99, imageUrl: 'https://picsum.photos/300/200?diavola'),
        MenuItemModel(id: 'i4', name: 'Fettuccine Alfredo', description: 'Creamy parmesan sauce with grilled chicken', price: 15.99, imageUrl: 'https://picsum.photos/300/200?alfredo'),
        MenuItemModel(id: 'i5', name: 'Seafood Risotto', description: 'Arborio rice with mixed seafood and saffron', price: 22.99, imageUrl: 'https://picsum.photos/300/200?risotto'),
        MenuItemModel(id: 'i6', name: 'Bruschetta Trio', description: 'Three varieties of toasted bread with toppings', price: 8.99, imageUrl: 'https://picsum.photos/300/200?bruschetta'),
        MenuItemModel(id: 'i7', name: 'Mozzarella Sticks', description: 'Golden fried mozzarella with marinara sauce', price: 7.99, imageUrl: 'https://picsum.photos/300/200?mozzarella'),
      ],
      'r2': [ // Burger Junction
        MenuItemModel(id: 'i1', name: 'The Junction Special', description: 'Double beef patty, bacon, cheese, special sauce', price: 13.99, imageUrl: 'https://picsum.photos/300/200?special'),
        MenuItemModel(id: 'i2', name: 'BBQ Ranch Burger', description: 'BBQ sauce, ranch, onion rings, cheddar', price: 12.99, imageUrl: 'https://picsum.photos/300/200?bbqranch'),
        MenuItemModel(id: 'i3', name: 'Mushroom Swiss', description: 'Sautéed mushrooms, swiss cheese, garlic aioli', price: 11.99, imageUrl: 'https://picsum.photos/300/200?mushroom'),
        MenuItemModel(id: 'i4', name: 'Crispy Chicken Deluxe', description: 'Fried chicken breast, lettuce, tomato, mayo', price: 10.99, imageUrl: 'https://picsum.photos/300/200?crispychicken'),
        MenuItemModel(id: 'i5', name: 'Fish & Chips', description: 'Beer-battered cod with seasoned fries', price: 14.99, imageUrl: 'https://picsum.photos/300/200?fishandchips'),
        MenuItemModel(id: 'i6', name: 'Loaded Fries', description: 'Fries topped with cheese, bacon, green onions', price: 6.99, imageUrl: 'https://picsum.photos/300/200?loadedfries'),
        MenuItemModel(id: 'i7', name: 'Onion Rings', description: 'Crispy beer-battered onion rings', price: 5.99, imageUrl: 'https://picsum.photos/300/200?onionrings'),
      ],
      'r3': [ // Sakura Sushi
        MenuItemModel(id: 'i1', name: 'Salmon Lover Set', description: '8 pieces of fresh salmon nigiri and sashimi', price: 18.99, imageUrl: 'https://picsum.photos/300/200?salmonset'),
        MenuItemModel(id: 'i2', name: 'Dragon Roll', description: 'Eel, cucumber, avocado with eel sauce', price: 14.99, imageUrl: 'https://picsum.photos/300/200?dragonroll'),
        MenuItemModel(id: 'i3', name: 'Rainbow Roll', description: 'California roll topped with assorted fish', price: 16.99, imageUrl: 'https://picsum.photos/300/200?rainbowroll'),
        MenuItemModel(id: 'i4', name: 'Chicken Teriyaki', description: 'Grilled chicken with teriyaki glaze and rice', price: 12.99, imageUrl: 'https://picsum.photos/300/200?teriyakichicken'),
        MenuItemModel(id: 'i5', name: 'Beef Yakitori', description: 'Grilled beef skewers with tare sauce', price: 15.99, imageUrl: 'https://picsum.photos/300/200?yakitori'),
        MenuItemModel(id: 'i6', name: 'Salmon Bento', description: 'Grilled salmon, rice, miso soup, salad', price: 16.99, imageUrl: 'https://picsum.photos/300/200?salmonbento'),
        MenuItemModel(id: 'i7', name: 'Chicken Katsu Bento', description: 'Fried chicken cutlet with curry sauce', price: 14.99, imageUrl: 'https://picsum.photos/300/200?katsubento'),
      ],
    };
    
    return itemMap[restaurantId] ?? [
      MenuItemModel(id: 'i1', name: 'House Special', description: 'Chef\'s signature dish', price: 16.99, imageUrl: 'https://picsum.photos/300/200?special1'),
      MenuItemModel(id: 'i2', name: 'Popular Choice', description: 'Customer favorite', price: 14.99, imageUrl: 'https://picsum.photos/300/200?popular1'),
      MenuItemModel(id: 'i3', name: 'Daily Fresh', description: 'Made with fresh ingredients', price: 12.99, imageUrl: 'https://picsum.photos/300/200?fresh1'),
      MenuItemModel(id: 'i4', name: 'Comfort Food', description: 'Hearty and satisfying', price: 13.99, imageUrl: 'https://picsum.photos/300/200?comfort1'),
    ];
  }
}
