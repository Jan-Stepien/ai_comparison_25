import 'package:equatable/equatable.dart';
import 'package:nomad_app/domain/entities/user_entity.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoaded extends AccountState {
  final UserEntity user;

  const AccountLoaded({required this.user});

  @override
  List<Object?> get props => [user];

  AccountLoaded copyWith({
    UserEntity? user,
  }) {
    return AccountLoaded(
      user: user ?? this.user,
    );
  }
}

class AccountUpdatedSuccess extends AccountState {
  final UserEntity user;

  const AccountUpdatedSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AccountPasswordChangeSuccess extends AccountState {
  const AccountPasswordChangeSuccess();
}

class AccountPhotoUpdateSuccess extends AccountState {
  final String photoUrl;

  const AccountPhotoUpdateSuccess({required this.photoUrl});

  @override
  List<Object?> get props => [photoUrl];
}

class AccountError extends AccountState {
  final String message;

  const AccountError({required this.message});

  @override
  List<Object?> get props => [message];
}