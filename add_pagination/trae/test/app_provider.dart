import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppProvider extends StatelessWidget {
  final Widget child;
  final List<RepositoryProvider>? repositories;

  const AppProvider({
    super.key,
    required this.child,
    this.repositories,
  });

  @override
  Widget build(BuildContext context) {
    final innerChild = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: child,
    );

    final providers = repositories ?? [];

    return providers.isEmpty
        ? innerChild
        : MultiRepositoryProvider(
            providers: providers,
            child: innerChild,
          );
  }
}
