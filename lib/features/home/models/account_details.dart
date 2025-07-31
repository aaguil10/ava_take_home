class AccountDetails {
  final int balance;
  final int creditLimit;
  final int spendLimit;
  final int currentSpend;

  const AccountDetails({
    required this.balance,
    required this.creditLimit,
    required this.spendLimit,
    required this.currentSpend,
  });

  /// Calculate utilization %
  double get utilization => (balance / creditLimit) * 100;
}
