// app_routes.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Auth Screens
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/signup_screen.dart';
import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/auth/views/splash_screen.dart';

// Other Screens
import '../../features/home/views/home_screen.dart';
import '../../features/restaurant/views/restaurant_screen.dart';
import '../../features/cart/views/cart_screen.dart';
import '../../features/cart/views/checkout_screen.dart';
import '../../features/payment/views/payment_methods_screen.dart';

import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [

      /// Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      /// Login
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      /// Signup
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      /// Forgot Password
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      /// Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      /// Restaurant details
      GoRoute(
        path: '${AppRoutes.restaurant}/:id',
        builder: (context, state) {
          final id = state.params['id']!;
          return RestaurantScreen(restaurantId: id);
        },
      ),

      /// Cart
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),

      /// Checkout
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),

      /// Payment
      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
    ],
  );
}
