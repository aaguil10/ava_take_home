class CreditCardAccount {
  final String name;
  final double balance;
  final double limit;
  final DateTime reportedAt;

  const CreditCardAccount({
    required this.name,
    required this.balance,
    required this.limit,
    required this.reportedAt,
  });

  /// Calculate utilization %
  double get utilization => (balance / limit) * 100;

  String get formattedUtilization => '${utilization.toStringAsFixed(0)}%';

  String get formattedBalance =>
      '\$${balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  String get formattedLimit =>
      '\$${limit.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  String get reportedDate =>
      '${_monthName(reportedAt.month)} ${reportedAt.day}, ${reportedAt.year}';

  static String _monthName(int month) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month];
  }
}
