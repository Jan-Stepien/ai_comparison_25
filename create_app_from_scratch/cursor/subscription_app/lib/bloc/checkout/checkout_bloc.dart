import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../services/payment_service.dart';
import '../../repositories/user_repository.dart';
import '../../core/models/user_model.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final AuthService _authService;
  final PaymentService _paymentService;
  final UserRepository _userRepository;

  CheckoutBloc({
    required AuthService authService,
    required PaymentService paymentService,
    required UserRepository userRepository,
  }) : _authService = authService,
       _paymentService = paymentService,
       _userRepository = userRepository,
       super(const CheckoutState()) {
    on<CheckoutPersonalDetailsSubmitted>(_onPersonalDetailsSubmitted);
    on<CheckoutPaymentDetailsSubmitted>(_onPaymentDetailsSubmitted);
    on<CheckoutAccountDetailsSubmitted>(_onAccountDetailsSubmitted);
    on<CheckoutAccountCreated>(_onAccountCreated);
    on<CheckoutStepChanged>(_onStepChanged);
    on<CheckoutReset>(_onReset);
  }

  void _onPersonalDetailsSubmitted(
    CheckoutPersonalDetailsSubmitted event,
    Emitter<CheckoutState> emit,
  ) {
    final personalDetails = PersonalDetails(
      name: event.name,
      surname: event.surname,
      email: event.email,
      phone: event.phone,
      country: event.country,
      region: event.region,
      city: event.city,
      postalCode: event.postalCode,
      address: event.address,
    );

    emit(state.copyWith(personalDetails: personalDetails, currentStep: 2));
  }

  void _onPaymentDetailsSubmitted(
    CheckoutPaymentDetailsSubmitted event,
    Emitter<CheckoutState> emit,
  ) {
    final paymentDetails = PaymentDetails(
      cardNumber: event.cardNumber,
      expiryDate: event.expiryDate,
      cvc: event.cvc,
      nameOnCard: event.nameOnCard,
    );

    emit(state.copyWith(paymentDetails: paymentDetails, currentStep: 3));
  }

  void _onAccountDetailsSubmitted(
    CheckoutAccountDetailsSubmitted event,
    Emitter<CheckoutState> emit,
  ) {
    final accountDetails = AccountDetails(
      name: event.name,
      surname: event.surname,
      email: event.email,
      phone: event.phone,
      country: event.country,
      region: event.region,
      city: event.city,
      postalCode: event.postalCode,
      address: event.address,
      cardNumber: event.cardNumber,
      expiryDate: event.expiryDate,
      cvc: event.cvc,
      nameOnCard: event.nameOnCard,
      photoUrl: event.photoUrl,
    );

    emit(state.copyWith(accountDetails: accountDetails, currentStep: 4));
  }

  Future<void> _onAccountCreated(
    CheckoutAccountCreated event,
    Emitter<CheckoutState> emit,
  ) async {
    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Passwords do not match',
        ),
      );
      return;
    }

    if (state.accountDetails == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: 'Account details are missing',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.loading));

    try {
      final accountDetails = state.accountDetails!;

      // Create Firebase user
      final userCredential = await _authService.createUserWithEmailAndPassword(
        accountDetails.email,
        event.password,
      );

      // Create subscription
      final subscription = SubscriptionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        planName: 'Pro',
        planPrice: 79.0,
        devicePackage: 'Nomad package',
        devicePrice: 120.0,
        totalPrice: 199.0,
        status: 'active',
        createdAt: DateTime.now(),
      );

      // Create user model
      final user = UserModel(
        id: userCredential.user!.uid,
        name: accountDetails.name,
        surname: accountDetails.surname,
        email: accountDetails.email,
        phone: accountDetails.phone,
        country: accountDetails.country,
        region: accountDetails.region,
        city: accountDetails.city,
        postalCode: accountDetails.postalCode,
        address: accountDetails.address,
        photoUrl: accountDetails.photoUrl,
        subscription: subscription,
        createdAt: DateTime.now(),
      );

      // Save user to Firestore
      await _userRepository.createUser(user);

      // Process payment (simplified - in production, integrate with Stripe properly)
      // await _paymentService.createSubscription(
      //   customerId: 'customer_id',
      //   priceId: 'price_id',
      // );

      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          user: user,
          subscription: subscription,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onStepChanged(CheckoutStepChanged event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onReset(CheckoutReset event, Emitter<CheckoutState> emit) {
    emit(const CheckoutState());
  }
}
