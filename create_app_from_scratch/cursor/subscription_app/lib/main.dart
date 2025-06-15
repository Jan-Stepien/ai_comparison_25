import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nomad_subscription_app/firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'services/auth_service.dart';
import 'services/payment_service.dart';
import 'repositories/user_repository.dart';
import 'bloc/checkout/checkout_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(
          create: (context) => FirebaseAuthService(),
        ),
        RepositoryProvider<PaymentService>(
          create: (context) => StripePaymentService(
            secretKey:
                'your_stripe_secret_key', // In production, use environment variables
          ),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => FirestoreUserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CheckoutBloc>(
            create: (context) => CheckoutBloc(
              authService: context.read<AuthService>(),
              paymentService: context.read<PaymentService>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'NOMAD Subscription',
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
          ],
        ),
      ),
    );
  }
}
