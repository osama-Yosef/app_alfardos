import 'package:flutter/cupertino.dart';

@immutable
abstract class ImplementState {}

class ImplementInitial extends ImplementState {}

class ImplementLoading extends ImplementState {}

class ImplementLoaded extends ImplementState {
  final List<Map<String, dynamic>> orders;
  ImplementLoaded(this.orders);
}

class ImplementError extends ImplementState {
  final String message;
  ImplementError(this.message);
}
