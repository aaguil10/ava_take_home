import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_card_account.dart';
import 'package:flutter/material.dart';

class CreditAccountCard extends StatelessWidget {
  final List<CreditCardAccount> accounts;

  const CreditAccountCard({super.key, required this.accounts});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 1.5,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: accounts.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 0, thickness: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, i) => _buildAccount(context, accounts[i]),
      ),
    );
  }

  Widget _buildAccount(BuildContext context, CreditCardAccount account) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameUtilizationRow(context, account),
          const SizedBox(height: 8),
          _buildProgressBar(context, account),
          const SizedBox(height: 12),
          _buildBalanceLimitRow(context, account),
          const SizedBox(height: 4),
          Text(
            'Reported on ${account.reportedDate}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildNameUtilizationRow(
    BuildContext context,
    CreditCardAccount account,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          account.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          account.formattedUtilization,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, CreditCardAccount account) {
    const barHeight = 8.0;
    const animationDuration = Duration(milliseconds: 800);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: account.utilization),
      duration: animationDuration,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Stack(
          children: [
            // background
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(15),
                borderRadius: BorderRadius.circular(barHeight / 2),
              ),
            ),
            // filled
            FractionallySizedBox(
              widthFactor: (value / 100).clamp(0.0, 1.0),
              child: Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: secondaryGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(barHeight / 2),
                    bottomLeft: Radius.circular(barHeight / 2),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBalanceLimitRow(
    BuildContext context,
    CreditCardAccount account,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${account.balance} Balance',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          '\$${account.limit} Limit',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
