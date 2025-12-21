import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ClientOrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientOrderInitial extends ClientOrderState {}

class ClientOrderLoading extends ClientOrderState {}

class ClientOrderLoaded extends ClientOrderState {
  final List<Map<String, dynamic>> orders;

  ClientOrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class ClientOrderError extends ClientOrderState {
  final String message;

  ClientOrderError(this.message);

  @override
  List<Object?> get props => [message];
}
