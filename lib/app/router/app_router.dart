import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:foodoko/app/router/routes.dart';

// Import your screens
import '../../features/auth/views/login_screen.dart';

import '../../features/auth/views/splash_screen.dart';

import '../../features/home/views/home_screen.dart';
import '../../features/restaurant/views/restaurant_screen.dart';

import '../../features/cart/views/cart_screen.dart';
import '../../features/cart/views/checkout_screen.dart';
import '../../features/payment/views/payment_methods_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '${AppRoutes.restaurant}/:id',
        builder: (context, state) {
          final id = state.params['id'];

          return RestaurantScreen(restaurantId: id!);
        },
      ),

      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),

      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),

      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
    ],
  );
}
