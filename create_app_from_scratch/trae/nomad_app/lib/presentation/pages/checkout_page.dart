import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_app/domain/entities/product_entity.dart';
import 'package:nomad_app/domain/entities/shipping_details.dart';
import 'package:nomad_app/presentation/bloc/checkout/checkout_bloc.dart';
import 'package:nomad_app/presentation/bloc/checkout/checkout_event.dart';
import 'package:nomad_app/presentation/bloc/checkout/checkout_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
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
  void initState() {
    super.initState();
    // Temporary user ID for demo purposes
    context.read<CheckoutBloc>().add(const CheckoutStarted(userId: 'user123'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutPaymentForm) {
            context.push('/payment');
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CheckoutShippingDetailsForm) {
            // Pre-fill form if shipping details exist
            if (state.shippingDetails != null) {
              _nameController.text = state.shippingDetails!.name;
              _surnameController.text = state.shippingDetails!.surname;
              _emailController.text = state.shippingDetails!.email;
              _phoneController.text = state.shippingDetails!.phoneNumber ?? '';
              _countryController.text = state.shippingDetails!.country;
              _regionController.text = state.shippingDetails!.region;
              _cityController.text = state.shippingDetails!.city;
              _postalCodeController.text = state.shippingDetails!.postalCode;
              _addressController.text = state.shippingDetails!.address;
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckoutProgress(),
                    const SizedBox(height: 24),
                    _buildShippingForm(),
                    const SizedBox(height: 24),
                    _buildProductSummary(),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildCheckoutProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('Personal details', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 12),
          width: 2,
          height: 16,
          color: Colors.green,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Text('2')),
              ),
              const SizedBox(width: 8),
              const Text('Checkout'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippingForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1. Shipping details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Please enter where you want us to deliver your Nomad package',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _surnameController,
            decoration: const InputDecoration(labelText: 'Surname'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your surname';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: 'Phone (optional)'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _countryController,
            decoration: const InputDecoration(labelText: 'Country'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your country';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _regionController,
            decoration: const InputDecoration(labelText: 'Region'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your region';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(labelText: 'City'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _postalCodeController,
            decoration: const InputDecoration(labelText: 'Postal code'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your postal code';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Submit shipping details
                  context.read<CheckoutBloc>().add(
                        ShippingDetailsSubmitted(
                          name: _nameController.text,
                          surname: _surnameController.text,
                          email: _emailController.text,
                          phoneNumber: _phoneController.text,
                          country: _countryController.text,
                          region: _regionController.text,
                          city: _cityController.text,
                          postalCode: _postalCodeController.text,
                          address: _addressController.text,
                        ),
                      );

                  // Select products (for demo purposes)
                  context.read<CheckoutBloc>().add(
                        CheckoutProductsSelected(
                          selectedProducts: [NomadPackage.standard()],
                        ),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Nomad package', style: TextStyle(color: Colors.white)),
              Text('109\$', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('"Pro" plan', style: TextStyle(color: Colors.white)),
              Text('79\$', style: TextStyle(color: Colors.white)),
            ],
          ),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Total', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Text('199\$', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}