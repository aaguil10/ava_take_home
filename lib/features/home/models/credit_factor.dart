class CreditFactor {
  final String name;
  final String value; // e.g., "100%", "4%"
  final String impact; // e.g., "High", "Low", "Medium"

  const CreditFactor({
    required this.name,
    required this.value,
    required this.impact,
  });
}
