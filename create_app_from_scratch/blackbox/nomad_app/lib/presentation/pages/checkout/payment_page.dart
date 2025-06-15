import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/strings.dart';
import '../../../presentation/blocs/checkout/checkout_bloc.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvcController = TextEditingController();
  final _nameOnCardController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvcController.dispose();
    _nameOnCardController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      context.read<CheckoutBloc>().add(
        UpdatePaymentDetails(
          cardNumber: _cardNumberController.text.trim(),
          expiryDate: _expiryDateController.text.trim(),
          cvc: _cvcController.text.trim(),
          nameOnCard: _nameOnCardController.text.trim(),
        ),
      );
      // Navigate to next page (CreateAccountPage)
      context.go('/create_account');
    }
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) return Strings.required;
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 13 || digitsOnly.length > 19)
      return Strings.invalidCard;
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) return Strings.required;
    final regex = RegExp(r'^\d{2}/\d{2}$');
    if (!regex.hasMatch(value)) return Strings.invalidDate;
    return null;
  }

  String? _validateCVC(String? value) {
    if (value == null || value.isEmpty) return Strings.required;
    if (value.length < 3 || value.length > 4) return Strings.invalidCVC;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.payment)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: Strings.cardNumber,
                ),
                keyboardType: TextInputType.number,
                validator: _validateCardNumber,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(
                        labelText: Strings.endDate,
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: _validateExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvcController,
                      decoration: const InputDecoration(labelText: Strings.cvc),
                      keyboardType: TextInputType.number,
                      validator: _validateCVC,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameOnCardController,
                decoration: const InputDecoration(
                  labelText: Strings.nameOnCard,
                ),
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
