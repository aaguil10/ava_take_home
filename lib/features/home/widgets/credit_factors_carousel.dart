import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_factor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A horizontal carousel showing credit factor cards.
class CreditFactorsCarousel extends StatelessWidget {
  /// List of credit factors to display.
  final List<CreditFactor> factors;

  const CreditFactorsCarousel({super.key, required this.factors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: factors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final factor = factors[index];
          return _CreditFactorCard(factor: factor);
        },
      ),
    );
  }
}

class _CreditFactorCard extends StatelessWidget {
  final CreditFactor factor;

  const _CreditFactorCard({super.key, required this.factor});

  Color _impactColor(String impact) {
    switch (impact) {
      case 'HIGH IMPACT':
        return textGreen;
      case 'MED IMPACT':
        return secondaryGreen;
      case 'LOW IMPACT':
      default:
        return secondaryGreenLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final impactColor = _impactColor(factor.impact);
    final textColor = factor.impact == 'LOW IMPACT' ? textGreen : Colors.white;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 2,
      child: Container(
        width: 145,
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              width: 90,
              child: Text(
                factor.name,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: textPrimaryDark),
              ),
            ),
            SizedBox(
              height: 26,
              child: Text(
                factor.value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: 27,
              width: 112,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: impactColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  minimumSize: const Size(0, 27),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: () {},
                child: Text(
                  factor.impact,
                  style: GoogleFonts.roboto(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
