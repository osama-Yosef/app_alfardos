abstract class ClientBalanceState {}

class ClientBalanceInitial extends ClientBalanceState {}

class ClientBalanceLoading extends ClientBalanceState {}

class ClientBalanceSuccess extends ClientBalanceState {
  final double balance;

  ClientBalanceSuccess(this.balance);
}

class ClientBalanceError extends ClientBalanceState {
  final String message;

  ClientBalanceError(this.message);


}

class ClientOrdersCountSuccess extends ClientBalanceState {
  final int inProgressCount;
  final int completedCount;

  ClientOrdersCountSuccess({
    required this.inProgressCount,
    required this.completedCount,
  });
}
