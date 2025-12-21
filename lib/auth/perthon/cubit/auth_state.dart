import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String role;
  final Map<String, dynamic>? userData;

  const AuthSuccess(this.role, {this.userData});

  @override
  List<Object?> get props => [role, userData];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordLoading extends AuthState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends AuthState {
  final String message;
  const ResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordError extends AuthState {
  final String message;
  const ResetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailVerificationSent extends AuthState {}

class EmailVerified extends AuthState {}

class EmailVerificationError extends AuthState {
  final String message;
  const EmailVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
