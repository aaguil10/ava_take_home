import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:ava_take_home/features/home/widgets/number_circle.dart';
import 'package:flutter/material.dart';

class TotalBalanceCard extends StatefulWidget {
  final List<CreditCardAccount> accounts;

  const TotalBalanceCard({super.key, required this.accounts});

  @override
  State<TotalBalanceCard> createState() => _TotalBalanceCardState();
}

class _TotalBalanceCardState extends State<TotalBalanceCard> {
  late final double totalBalance;
  late final double totalLimit;
  late final double utilization;

  double _sumBy(
    List<CreditCardAccount> accounts,
    double Function(CreditCardAccount) selector,
  ) => accounts.fold(0, (sum, account) => sum + selector(account));

  @override
  void initState() {
    super.initState();
    totalBalance = _sumBy(widget.accounts, (a) => a.balance);
    totalLimit = _sumBy(widget.accounts, (a) => a.limit);
    utilization = totalLimit == 0 ? 0 : totalBalance / totalLimit;
  }

  String get formattedBalance =>
      '\$${totalBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  String get formattedLimit =>
      '\$${totalLimit.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  final List<Map<String, dynamic>> _ranges = [
    {
      'max': 10.0,
      'label': 'Excellent',
      'color': secondaryGreen,
      'range': '0-9%',
    },
    {'max': 30.0, 'label': 'Good', 'color': secondaryGreen, 'range': '10-29%'},
    {'max': 50.0, 'label': 'Fair', 'color': okOrange, 'range': '30-49%'},
    {'max': 75.0, 'label': 'Poor', 'color': notGoodRed, 'range': '50-74%'},
    {
      'max': double.infinity,
      'label': 'Bad',
      'color': notGoodRed,
      'range': '<75%',
    },
  ];

  Map<String, dynamic> get _ratingInfo {
    final percent = utilization * 100;
    return _ranges.firstWhere((r) => percent < r['max']);
  }

  String get rating => _ratingInfo['label'];

  Color get ratingColor => _ratingInfo['color'];

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            // Top row: total balance + donut
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildBalanceInfo(context)),
                NumberCircle(number: utilization, label: rating, maxNumber: 1),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRangeBarLabel(context),
                _buildRangeBar(context),
                _buildPercentageTicks(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Total balance: ',
            style: Theme.of(context).textTheme.titleMedium,
            children: [
              TextSpan(
                text: formattedBalance,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total limit: $formattedLimit',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: textLight),
        ),
      ],
    );
  }

  Widget _buildRangeBarLabel(BuildContext context) {
    final groups = [
      _ranges.where((r) => ['Excellent', 'Good'].contains(r['label'])),
      _ranges.where((r) => r['label'] == 'Fair'),
      _ranges.where((r) => ['Poor', 'Bad'].contains(r['label'])),
    ];

    return SizedBox(
      height: 24,
      child: Row(
        children: groups.map((group) {
          final isActive = group.any((r) => r['label'] == rating);
          return Expanded(
            child: isActive
                ? Text(
                    rating, // Use the current rating directly
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ratingColor, // Use the getter instead of a param
                    ),
                  )
                : const SizedBox(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRangeBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 24,
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryGreen,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container(color: okOrange)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: notGoodRed,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPercentageTicks() {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPercentageLabels(CrossAxisAlignment.start, _ranges[0]),
                _buildPercentageLabels(CrossAxisAlignment.end, _ranges[1]),
              ],
            ),
          ),
          Expanded(
            child: _buildPercentageLabels(
              CrossAxisAlignment.center,
              _ranges[2],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPercentageLabels(CrossAxisAlignment.start, _ranges[3]),
                _buildPercentageLabels(CrossAxisAlignment.end, _ranges[4]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageLabels(
    CrossAxisAlignment crossAxisAlignment,
    Map<String, dynamic> range,
  ) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Container(
          width: 1,
          height: 8,
          color: rating == range['label'] ? ratingColor : disabledGray,
        ),
        Text(
          range['range'],
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: rating == range['label'] ? ratingColor : textLight,
          ),
        ),
      ],
    );
  }
}
