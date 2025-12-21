import 'package:meta/meta.dart';

import '../../data/model/model_prise.dart';

@immutable
abstract class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final List<PricingModel> orders;
  SettingLoaded({required this.orders});
}

class SettingError extends SettingState {
  final String message;
  SettingError(this.message);
}
