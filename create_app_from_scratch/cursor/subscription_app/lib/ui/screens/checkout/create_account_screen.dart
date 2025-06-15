import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../bloc/checkout/checkout_bloc.dart';
import '../../../bloc/checkout/checkout_event.dart';
import '../../../core/router/app_router.dart';
import '../../widgets/checkout_header.dart';
import '../../widgets/custom_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvcController = TextEditingController();
  final _nameOnCardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fillFormWithExistingData();
  }

  void _fillFormWithExistingData() {
    final state = context.read<CheckoutBloc>().state;

    if (state.personalDetails != null) {
      _nameController.text = state.personalDetails!.name;
      _surnameController.text = state.personalDetails!.surname;
      _emailController.text = state.personalDetails!.email;
      _phoneController.text = state.personalDetails!.phone;
      _countryController.text = state.personalDetails!.country;
      _regionController.text = state.personalDetails!.region;
      _cityController.text = state.personalDetails!.city;
      _postalCodeController.text = state.personalDetails!.postalCode;
      _addressController.text = state.personalDetails!.address;
    }

    if (state.paymentDetails != null) {
      _cardNumberController.text = state.paymentDetails!.cardNumber;
      _expiryDateController.text = state.paymentDetails!.expiryDate;
      _cvcController.text = state.paymentDetails!.cvc;
      _nameOnCardController.text = state.paymentDetails!.nameOnCard;
    }
  }

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
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _nameOnCardController.dispose();
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
          onPressed: () => context.go(AppRouter.payment),
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
            currentStep: 3,
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
                    l10n.createAccount,
                    style: theme.textTheme.displaySmall,
                  ),

                  const SizedBox(height: 24),

                  // Plan details
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.yourPlan,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          l10n.pro,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '79\$${l10n.perMonth}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                theme.colorScheme.onSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Create account form
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
                                    '3',
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
                                l10n.createAccount,
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            l10n.fillFormToCreateAccount,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Photo upload
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.outline.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withOpacity(0.3),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: () {
                                    // TODO: Implement photo picker
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 24,
                                        color: theme.colorScheme.outline,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.addPhoto,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          Text(
                            l10n.personalData,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _nameController,
                            label: l10n.name,
                            hintText: l10n.enterYourName,
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _surnameController,
                            label: l10n.surname,
                            hintText: l10n.enterYourSurname,
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _emailController,
                            label: l10n.email,
                            hintText: l10n.enterYourEmail,
                            keyboardType: TextInputType.emailAddress,
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
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _regionController,
                            label: l10n.region,
                            hintText: l10n.enterYourRegion,
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _cityController,
                            label: l10n.city,
                            hintText: l10n.enterYourCity,
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _postalCodeController,
                            label: l10n.postalCode,
                            hintText: l10n.enterYourPostalCode,
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _addressController,
                            label: l10n.address,
                            hintText: l10n.enterYourAddress,
                            maxLines: 3,
                          ),

                          const SizedBox(height: 32),

                          Text(
                            l10n.paymentInformation,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _cardNumberController,
                            label: l10n.cardNumber,
                            hintText: '1111 2222 4444 5555',
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _expiryDateController,
                                  label: l10n.endDate,
                                  hintText: '01/26',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  controller: _cvcController,
                                  label: l10n.cvcCvv,
                                  hintText: '123',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          CustomTextField(
                            controller: _nameOnCardController,
                            label: l10n.nameOnCard,
                            hintText: 'Anna Kowalska',
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
    context.read<CheckoutBloc>().add(
          CheckoutAccountDetailsSubmitted(
            name: _nameController.text,
            surname: _surnameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            country: _countryController.text,
            region: _regionController.text,
            city: _cityController.text,
            postalCode: _postalCodeController.text,
            address: _addressController.text,
            cardNumber: _cardNumberController.text,
            expiryDate: _expiryDateController.text,
            cvc: _cvcController.text,
            nameOnCard: _nameOnCardController.text,
          ),
        );

    context.go(AppRouter.password);
  }
}
