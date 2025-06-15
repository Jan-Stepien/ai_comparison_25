import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../bloc/checkout/checkout_bloc.dart';
import '../../../bloc/checkout/checkout_event.dart';
import '../../../core/router/app_router.dart';
import '../../widgets/checkout_header.dart';
import '../../widgets/device_plan_card.dart';
import '../../widgets/custom_text_field.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(l10n.appTitle),
          ],
        ),
      ),
      body: Column(
        children: [
          // Checkout header with steps
          CheckoutHeader(
            currentStep: 1,
            steps: [
              l10n.personalDetails,
              l10n.payment,
              l10n.createAccount,
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.checkout,
                    style: theme.textTheme.displaySmall,
                  ),

                  const SizedBox(height: 24),

                  // Device & plan details card
                  const DevicePlanCard(),

                  const SizedBox(height: 24),

                  // Shipping details form
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.shippingDetails,
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.enterAddressDescription,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomTextField(
                            controller: _nameController,
                            label: l10n.name,
                            hintText: l10n.enterYourName,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _surnameController,
                            label: l10n.surname,
                            hintText: l10n.enterYourSurname,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Surname is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _emailController,
                            label: l10n.email,
                            hintText: l10n.enterYourEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value!)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _phoneController,
                            label: l10n.phoneOptional,
                            hintText: l10n.enterYourPhone,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _countryController,
                            label: l10n.country,
                            hintText: l10n.enterYourCountry,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Country is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _regionController,
                            label: l10n.region,
                            hintText: l10n.enterYourRegion,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Region is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _cityController,
                            label: l10n.city,
                            hintText: l10n.enterYourCity,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'City is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _postalCodeController,
                            label: l10n.postalCode,
                            hintText: l10n.enterYourPostalCode,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Postal code is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _addressController,
                            label: l10n.address,
                            hintText: l10n.enterYourAddress,
                            maxLines: 3,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Address is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: Text(l10n.continueButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CheckoutBloc>().add(
            CheckoutPersonalDetailsSubmitted(
              name: _nameController.text,
              surname: _surnameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              country: _countryController.text,
              region: _regionController.text,
              city: _cityController.text,
              postalCode: _postalCodeController.text,
              address: _addressController.text,
            ),
          );

      context.go(AppRouter.payment);
    }
  }
}
