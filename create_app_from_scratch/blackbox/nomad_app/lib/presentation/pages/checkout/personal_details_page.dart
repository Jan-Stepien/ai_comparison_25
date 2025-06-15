import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../presentation/blocs/checkout/checkout_bloc.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      context.read<CheckoutBloc>().add(
        UpdatePersonalDetails(
          name: _nameController.text.trim(),
          surname: _surnameController.text.trim(),
          email: _emailController.text.trim(),
          phone:
              _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
          country: _countryController.text.trim(),
          region: _regionController.text.trim(),
          city: _cityController.text.trim(),
          postalCode: _postalCodeController.text.trim(),
          address: _addressController.text.trim(),
        ),
      );
      // Navigate to next page (PaymentPage)
      context.go('/payment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.personalDetails)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: Strings.name),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: Strings.surname),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: Strings.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return Strings.required;
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) return Strings.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: Strings.phone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: Strings.country),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _regionController,
                decoration: const InputDecoration(labelText: Strings.region),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: Strings.city),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: Strings.postalCode,
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: Strings.address),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? Strings.required
                            : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onContinue,
                child: const Text(Strings.continue_),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
