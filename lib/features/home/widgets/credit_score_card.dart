import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';
import 'package:ava_take_home/features/home/widgets/number_circle.dart';
import 'package:flutter/material.dart';

class CreditScoreCard extends StatelessWidget {
  final List<CreditScore> history;

  const CreditScoreCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final int score = history.isNotEmpty ? history.last.value : 0;
    final String label = history.isNotEmpty ? history.last.label : '';
    final int delta = (history.length >= 2)
        ? history.last.value - history[history.length - 2].value
        : 0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 72,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(context, delta),
                        Text(
                          'Updated Today | Next May 12',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Text(
                      'Experian',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: primaryPurpleLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 50),
              NumberCircle(
                number: score.toDouble(),
                maxNumber: 850,
                label: label,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, int delta) {
    return Row(
      children: [
        Text("Credit Score", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 8),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 20,
              width: 50,
              decoration: BoxDecoration(
                color: delta > 0 ? secondaryGreen : notGoodRed,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              delta > 0 ? "+${delta}pts" : "${delta}pts",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
