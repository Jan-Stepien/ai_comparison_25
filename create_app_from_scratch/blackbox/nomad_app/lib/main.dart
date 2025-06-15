import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/checkout/personal_details_page.dart';
import 'presentation/pages/checkout/payment_page.dart';
import 'presentation/pages/checkout/create_account_page.dart';
import 'presentation/pages/success_page.dart';
import 'presentation/blocs/checkout/checkout_bloc.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/payment_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authService = AuthService();
  final databaseService = DatabaseService();
  final paymentService = PaymentService();

  final authRepository = AuthRepositoryImpl(authService);
  final userRepository = UserRepositoryImpl(databaseService);

  runApp(
    MyApp(
      authRepository: authRepository,
      userRepository: userRepository,
      paymentService: paymentService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final UserRepositoryImpl userRepository;
  final PaymentService paymentService;

  MyApp({
    required this.authRepository,
    required this.userRepository,
    required this.paymentService,
    super.key,
  });

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/personal_details',
        name: '/personal_details',
        builder: (context, state) => const PersonalDetailsPage(),
      ),
      GoRoute(
        path: '/payment',
        name: '/payment',
        builder: (context, state) => const PaymentPage(),
      ),
      GoRoute(
        path: '/create_account',
        name: '/create_account',
        builder: (context, state) => const CreateAccountPage(),
      ),
      GoRoute(
        path: '/success',
        name: '/success',
        builder: (context, state) => const SuccessPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: userRepository),
      ],
      child: BlocProvider(
        create: (_) => CheckoutBloc(userRepository, paymentService),
        child: MaterialApp.router(
          title: 'Nomad',
          theme: AppTheme.lightTheme,
          routerConfig: _router,
          localizationsDelegates: const [
            // Add flutter_localizations delegates here if needed
          ],
          supportedLocales: const [Locale('en', '')],
        ),
      ),
    );
  }
}
