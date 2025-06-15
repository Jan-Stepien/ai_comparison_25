import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/strings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.appName)),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/personal_details');
          },
          child: const Text('Start Checkout'),
        ),
      ),
    );
  }
}
