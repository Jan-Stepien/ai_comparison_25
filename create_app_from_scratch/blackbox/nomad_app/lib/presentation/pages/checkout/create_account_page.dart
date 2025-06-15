import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../presentation/blocs/checkout/checkout_bloc.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRepeatPasswordVisibility() {
    setState(() {
      _obscureRepeatPassword = !_obscureRepeatPassword;
    });
  }

  void _onCreateAccount() {
    if (_formKey.currentState!.validate()) {
      // Here you would trigger the account creation logic, e.g., Firebase Auth sign up
      // For now, just navigate to success page
      context.go('/success');
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return Strings.required;
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateRepeatPassword(String? value) {
    if (value == null || value.isEmpty) return Strings.required;
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.createAccountTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'You’re almost set. Set your password and create the account.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscurePassword,
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repeatPasswordController,
                decoration: InputDecoration(
                  labelText: 'Repeat new password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureRepeatPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: _toggleRepeatPasswordVisibility,
                  ),
                ),
                obscureText: _obscureRepeatPassword,
                validator: _validateRepeatPassword,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onCreateAccount,
                child: const Text(Strings.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
