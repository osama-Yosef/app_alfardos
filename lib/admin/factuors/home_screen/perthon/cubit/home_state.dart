part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeOrdersLoaded extends HomeState {
  final List<HomeActiveOrder> orders;
  final int inProgressCount;

  HomeOrdersLoaded(this.orders, this.inProgressCount);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
