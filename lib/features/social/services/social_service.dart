// lib/features/social/services/social_service.dart

class SocialService {
  static final List<Map<String, dynamic>> _friends = [
    {'id': '1', 'name': 'Sarah Johnson', 'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop', 'status': 'online'},
    {'id': '2', 'name': 'Mike Chen', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop', 'status': 'ordering'},
    {'id': '3', 'name': 'Emma Davis', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop', 'status': 'offline'},
  ];

  static final List<Map<String, dynamic>> _groupOrders = [];
  static final List<Map<String, dynamic>> _foodieEvents = [];

  // Get user's friends list
  static List<Map<String, dynamic>> getFriends() {
    return _friends;
  }

  // Create group order
  static String createGroupOrder(String restaurantId, String creatorId) {
    final groupOrderId = 'group_${DateTime.now().millisecondsSinceEpoch}';
    final groupOrder = {
      'id': groupOrderId,
      'restaurantId': restaurantId,
      'creatorId': creatorId,
      'participants': [creatorId],
      'orders': {},
      'status': 'open',
      'createdAt': DateTime.now().toIso8601String(),
      'deadline': DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
    };
    
    _groupOrders.add(groupOrder);
    return groupOrderId;
  }

  // Join group order
  static bool joinGroupOrder(String groupOrderId, String userId) {
    final groupOrder = _groupOrders.firstWhere((order) => order['id'] == groupOrderId);
    if (groupOrder['status'] == 'open') {
      (groupOrder['participants'] as List).add(userId);
      return true;
    }
    return false;
  }

  // Add item to group order
  static void addItemToGroupOrder(String groupOrderId, String userId, Map<String, dynamic> item) {
    final groupOrder = _groupOrders.firstWhere((order) => order['id'] == groupOrderId);
    final orders = groupOrder['orders'] as Map<String, dynamic>;
    
    if (!orders.containsKey(userId)) {
      orders[userId] = [];
    }
    (orders[userId] as List).add(item);
  }

  // Get group orders
  static List<Map<String, dynamic>> getGroupOrders() {
    return _groupOrders;
  }

  // Share food photo
  static Map<String, dynamic> shareFoodPhoto(String userId, String imageUrl, String caption, String restaurantId) {
    final post = {
      'id': 'post_${DateTime.now().millisecondsSinceEpoch}',
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'restaurantId': restaurantId,
      'likes': 0,
      'comments': [],
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    return post;
  }

  // Get food feed (social posts)
  static List<Map<String, dynamic>> getFoodFeed() {
    return [
      {
        'id': 'post_1',
        'user': {'name': 'Sarah J.', 'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=50&h=50&fit=crop'},
        'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
        'caption': 'Amazing pizza night! 🍕✨',
        'restaurant': 'Pizza Palace',
        'likes': 24,
        'comments': 5,
        'timestamp': '2 hours ago',
      },
      {
        'id': 'post_2',
        'user': {'name': 'Mike C.', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop'},
        'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop',
        'caption': 'Healthy lunch goals achieved! 🥗💪',
        'restaurant': 'Green Garden',
        'likes': 18,
        'comments': 3,
        'timestamp': '4 hours ago',
      },
    ];
  }

  // Create foodie event
  static String createFoodieEvent(String title, String description, String restaurantId, DateTime dateTime) {
    final eventId = 'event_${DateTime.now().millisecondsSinceEpoch}';
    final event = {
      'id': eventId,
      'title': title,
      'description': description,
      'restaurantId': restaurantId,
      'dateTime': dateTime.toIso8601String(),
      'attendees': [],
      'maxAttendees': 10,
      'createdBy': 'current_user',
    };
    
    _foodieEvents.add(event);
    return eventId;
  }

  // Get foodie events
  static List<Map<String, dynamic>> getFoodieEvents() {
    return [
      {
        'id': 'event_1',
        'title': 'Pizza Tasting Night',
        'description': 'Join us for an amazing pizza tasting experience!',
        'restaurant': 'Pizza Palace',
        'dateTime': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'attendees': 8,
        'maxAttendees': 15,
        'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop',
      },
      {
        'id': 'event_2',
        'title': 'Healthy Cooking Workshop',
        'description': 'Learn to make nutritious and delicious meals',
        'restaurant': 'Green Garden',
        'dateTime': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        'attendees': 12,
        'maxAttendees': 20,
        'imageUrl': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=200&fit=crop',
      },
    ];
  }

  // Rate and review system
  static void submitReview(String restaurantId, String userId, double rating, String review) {
    // Implementation for submitting reviews
  }

  // Get restaurant reviews
  static List<Map<String, dynamic>> getRestaurantReviews(String restaurantId) {
    return [
      {
        'id': 'review_1',
        'user': {'name': 'John D.', 'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=50&h=50&fit=crop'},
        'rating': 4.5,
        'review': 'Excellent food and great service! The pasta was perfectly cooked.',
        'timestamp': '1 day ago',
        'helpful': 12,
      },
      {
        'id': 'review_2',
        'user': {'name': 'Lisa M.', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50&fit=crop'},
        'rating': 5.0,
        'review': 'Best pizza in town! Fast delivery and hot food.',
        'timestamp': '3 days ago',
        'helpful': 8,
      },
    ];
  }

  // Food challenges and achievements
  static List<Map<String, dynamic>> getFoodChallenges() {
    return [
      {
        'id': 'challenge_1',
        'title': 'Healthy Week Challenge',
        'description': 'Order healthy meals for 7 consecutive days',
        'progress': 3,
        'target': 7,
        'reward': '20% off next order',
        'icon': '🥗',
      },
      {
        'id': 'challenge_2',
        'title': 'Explorer Badge',
        'description': 'Try 5 different cuisines this month',
        'progress': 2,
        'target': 5,
        'reward': 'Free dessert',
        'icon': '🌍',
      },
    ];
  }
}