import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomad_app/domain/entities/user_entity.dart';
import 'package:nomad_app/domain/repositories/user_repository.dart';
import 'package:nomad_app/presentation/bloc/account/account_event.dart';
import 'package:nomad_app/presentation/bloc/account/account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserRepository _userRepository;

  AccountBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const AccountInitial()) {
    on<AccountRequested>(_onAccountRequested);
    on<AccountUpdated>(_onAccountUpdated);
    on<ShippingDetailsUpdated>(_onShippingDetailsUpdated);
    on<AccountPasswordChanged>(_onAccountPasswordChanged);
    on<AccountPhotoUpdated>(_onAccountPhotoUpdated);
  }

  Future<void> _onAccountRequested(AccountRequested event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final user = await _userRepository.getUser(event.userId);
      if (user != null) {
        emit(AccountLoaded(user: user));
      } else {
        emit(const AccountError(message: 'User not found'));
      }
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> _onAccountUpdated(AccountUpdated event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      // Get the current user first
      final currentUser = await _userRepository.getUser(event.userId);
      if (currentUser == null) {
        emit(const AccountError(message: 'User not found'));
        return;
      }
      
      // Update with new values
      final updatedUser = currentUser.copyWith(
        name: event.name,
        surname: event.surname,
        phone: event.phone,
      );
      
      await _userRepository.updateUser(updatedUser);
      emit(AccountLoaded(user: updatedUser));
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> _onShippingDetailsUpdated(ShippingDetailsUpdated event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final shippingDetails = ShippingDetails(
        fullName: '${event.name} ${event.surname}',
        address: event.address,
        city: event.city,
        postalCode: event.postalCode,
        country: event.country,
        region: event.region,
      );
      
      await _userRepository.updateShippingDetails(event.userId, shippingDetails);
      
      // Get the updated user to reflect changes
      final updatedUser = await _userRepository.getUser(event.userId);
      if (updatedUser != null) {
        emit(AccountLoaded(user: updatedUser));
      } else {
        emit(const AccountError(message: 'Failed to get updated user'));
      }
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> _onAccountPasswordChanged(AccountPasswordChanged event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      // In a real app, you would call a method to change the password
      // For now, we'll just simulate success
      await Future.delayed(const Duration(seconds: 1));
      emit(const AccountPasswordChangeSuccess());
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }

  Future<void> _onAccountPhotoUpdated(AccountPhotoUpdated event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      // In a real app, you would upload the photo and get a URL
      // For now, we'll just simulate success with a fake URL
      const photoUrl = 'https://example.com/photos/user_profile.jpg';
      
      // Get the current user
      final currentUser = await _userRepository.getUser(event.userId);
      if (currentUser == null) {
        emit(const AccountError(message: 'User not found'));
        return;
      }
      
      // Since UserEntity doesn't have a photoUrl field, we can't update it directly
      // In a real app, you would need to extend the UserEntity class or store the photo URL elsewhere
      
      emit(AccountLoaded(user: currentUser));
    } catch (e) {
      emit(AccountError(message: e.toString()));
    }
  }
}