import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/models/package_model.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../services/payment_service.dart';

// Events
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePersonalDetails extends CheckoutEvent {
  final String name;
  final String surname;
  final String email;
  final String? phone;
  final String country;
  final String region;
  final String city;
  final String postalCode;
  final String address;

  const UpdatePersonalDetails({
    required this.name,
    required this.surname,
    required this.email,
    this.phone,
    required this.country,
    required this.region,
    required this.city,
    required this.postalCode,
    required this.address,
  });

  @override
  List<Object?> get props => [
    name,
    surname,
    email,
    phone,
    country,
    region,
    city,
    postalCode,
    address,
  ];
}

class UpdatePaymentDetails extends CheckoutEvent {
  final String cardNumber;
  final String expiryDate;
  final String cvc;
  final String nameOnCard;

  const UpdatePaymentDetails({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvc,
    required this.nameOnCard,
  });

  @override
  List<Object?> get props => [cardNumber, expiryDate, cvc, nameOnCard];
}

class ProcessPayment extends CheckoutEvent {
  const ProcessPayment();
}

class ResetCheckout extends CheckoutEvent {
  const ResetCheckout();
}

// States
abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutPersonalDetailsUpdated extends CheckoutState {
  final UserModel user;

  const CheckoutPersonalDetailsUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class CheckoutPaymentDetailsUpdated extends CheckoutState {
  final UserModel user;
  final PaymentModel payment;

  const CheckoutPaymentDetailsUpdated(this.user, this.payment);

  @override
  List<Object?> get props => [user, payment];
}

class CheckoutSuccess extends CheckoutState {
  final OrderModel order;

  const CheckoutSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final UserRepository _userRepository;
  final PaymentService _paymentService;

  UserModel? _currentUser;
  PaymentModel? _currentPayment;
  final List<PackageModel> _packages = [
    PackageModel.nomadPackage,
    PackageModel.proPackage,
  ];

  CheckoutBloc(this._userRepository, this._paymentService)
    : super(CheckoutInitial()) {
    on<UpdatePersonalDetails>(_onUpdatePersonalDetails);
    on<UpdatePaymentDetails>(_onUpdatePaymentDetails);
    on<ProcessPayment>(_onProcessPayment);
    on<ResetCheckout>(_onResetCheckout);
  }

  void _onUpdatePersonalDetails(
    UpdatePersonalDetails event,
    Emitter<CheckoutState> emit,
  ) {
    _currentUser = UserModel(
      id: '', // Will be set after authentication
      email: event.email,
      name: event.name,
      surname: event.surname,
      phone: event.phone,
      country: event.country,
      region: event.region,
      city: event.city,
      postalCode: event.postalCode,
      address: event.address,
    );

    emit(CheckoutPersonalDetailsUpdated(_currentUser!));
  }

  void _onUpdatePaymentDetails(
    UpdatePaymentDetails event,
    Emitter<CheckoutState> emit,
  ) {
    _currentPayment = PaymentModel(
      cardNumber: event.cardNumber,
      expiryDate: event.expiryDate,
      cvc: event.cvc,
      nameOnCard: event.nameOnCard,
    );

    if (_currentUser != null) {
      emit(CheckoutPaymentDetailsUpdated(_currentUser!, _currentPayment!));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    if (_currentUser == null || _currentPayment == null) {
      emit(const CheckoutError('Missing user or payment information'));
      return;
    }

    emit(CheckoutLoading());

    try {
      // Calculate total
      final total = _packages.fold<double>(
        0.0,
        (sum, package) => sum + package.price,
      );

      // Validate payment details
      final isValidCard = await _paymentService.validateCard(
        cardNumber: _currentPayment!.cardNumber,
        expiryDate: _currentPayment!.expiryDate,
        cvc: _currentPayment!.cvc,
      );

      if (!isValidCard) {
        emit(const CheckoutError('Invalid payment details'));
        return;
      }

      // Process payment
      await _paymentService.processPayment(
        paymentDetails: _currentPayment!,
        amount: total,
        currency: 'usd',
      );

      // Create order
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        user: _currentUser!,
        packages: _packages,
        payment: _currentPayment!,
        total: total,
        createdAt: DateTime.now(),
        status: 'completed',
      );

      final orderId = await _userRepository.createOrder(order);
      final finalOrder = order.copyWith(id: orderId);

      emit(CheckoutSuccess(finalOrder));
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  void _onResetCheckout(ResetCheckout event, Emitter<CheckoutState> emit) {
    _currentUser = null;
    _currentPayment = null;
    emit(CheckoutInitial());
  }

  double get totalAmount =>
      _packages.fold<double>(0.0, (sum, package) => sum + package.price);

  List<PackageModel> get packages => _packages;
  UserModel? get currentUser => _currentUser;
  PaymentModel? get currentPayment => _currentPayment;
}
