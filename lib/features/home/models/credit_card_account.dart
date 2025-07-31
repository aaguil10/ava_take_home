class CreditCardAccount {
  final String name; // e.g., "Syncb/Amazon"
  final double balance; // current balance
  final double limit; // credit limit

  const CreditCardAccount({
    required this.name,
    required this.balance,
    required this.limit,
  });

  /// Calculate utilization %
  double get utilization => (balance / limit) * 100;
}
