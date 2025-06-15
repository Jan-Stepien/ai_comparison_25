import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/screens/home_screen.dart';
import '../../ui/screens/checkout/personal_details_screen.dart';
import '../../ui/screens/checkout/payment_screen.dart';
import '../../ui/screens/checkout/create_account_screen.dart';
import '../../ui/screens/checkout/password_screen.dart';
import '../../ui/screens/success_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String personalDetails = '/checkout/personal-details';
  static const String payment = '/checkout/payment';
  static const String createAccount = '/checkout/create-account';
  static const String password = '/checkout/password';
  static const String success = '/success';

  static final GoRouter _router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: personalDetails,
        builder: (context, state) => const PersonalDetailsScreen(),
      ),
      GoRoute(
        path: payment,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: createAccount,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: password,
        builder: (context, state) => const PasswordScreen(),
      ),
      GoRoute(
        path: success,
        builder: (context, state) => const SuccessScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );

  static GoRouter get router => _router;
}
