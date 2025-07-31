import 'dart:math' as math;

import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/account_details.dart';
import 'package:flutter/material.dart';

class SpendLimitCard extends StatefulWidget {
  final AccountDetails accountDetails;

  const SpendLimitCard({super.key, required this.accountDetails});

  @override
  State<SpendLimitCard> createState() => _SpendLimitCardState();
}

class _SpendLimitCardState extends State<SpendLimitCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnim;

  // Todo(Alejandro): Ask product manager what the green marker represents.
  double get spendToCreditRatio =>
      (widget.accountDetails.spendLimit / widget.accountDetails.creditLimit)
          .clamp(0.0, 1.0);

  // Todo(Alejandro): Ask product manager what the purple marker represents.
  double get spendProgress =>
      (widget.accountDetails.currentSpend / widget.accountDetails.spendLimit)
          .clamp(0.0, 1.0) *
      spendToCreditRatio;

  String get formattedBalance =>
      '\$${widget.accountDetails.balance.toStringAsFixed(0)}';

  String get formattedLimit =>
      '\$${widget.accountDetails.creditLimit.toStringAsFixed(0)}';

  String get utilizationPercent =>
      '${widget.accountDetails.utilization.toStringAsFixed(0)}%';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progressAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SpendLimitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountDetails.currentSpend !=
        widget.accountDetails.currentSpend) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            _buildProgressBar(context),
            _buildSpendLimitLine(),
            const SizedBox(height: 8),
            _buildBalanceCreditLimitRow(),
            const Divider(thickness: 1),
            const SizedBox(height: 4),
            _buildUtilizationRow(context, utilizationPercent),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barHeight = 8.0;
        return SizedBox(
          height: 60,
          child: AnimatedBuilder(
            animation: _progressAnim,
            builder: (BuildContext context, Widget? child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background bar
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 46,
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: secondaryGreenLight,
                        borderRadius: BorderRadius.circular(barHeight / 2),
                      ),
                    ),
                  ),
                  // Green progress marker
                  Positioned(
                    left:
                        constraints.maxWidth *
                        spendToCreditRatio *
                        _progressAnim.value,
                    // center the line
                    top: 46,
                    child: Container(
                      width: 4,
                      height: barHeight,
                      color: secondaryGreen,
                    ),
                  ),
                  // Purple marker
                  _buildMarker(context, constraints.maxWidth),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Tooltip positioned over the currentSpend marker
  Widget _buildMarker(BuildContext context, double width) {
    final markerPosition =
        width * spendToCreditRatio * spendProgress * _progressAnim.value;
    return Positioned(
      left: math.max(0.0, math.min(width, markerPosition)),
      top: 0,
      child: Column(
        children: [
          // Tooltip bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '\$${widget.accountDetails.currentSpend.toStringAsFixed(0)}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: textManilla),
            ),
          ),
          // Arrow
          SizedBox(
            height: 6,
            width: 20,
            child: CustomPaint(
              painter: _TriangleDownPainter(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Spend limit line with question link
  Widget _buildSpendLimitLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Spend limit: \$${widget.accountDetails.spendLimit.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {}, // hook for explanation
          child: Text(
            'Why is it different?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: primaryPurpleLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCreditLimitRow() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAmountColumn(
            formattedBalance,
            'Balance',
            CrossAxisAlignment.start,
          ),
          _buildAmountColumn(
            formattedLimit,
            'Credit limit',
            CrossAxisAlignment.end,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountColumn(
    String amount,
    String label,
    CrossAxisAlignment columnAlignment,
  ) {
    return Column(
      crossAxisAlignment: columnAlignment,
      children: [
        Text(amount, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

Widget _buildUtilizationRow(BuildContext context, String utilizationPercent) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Utilization',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
      Text(utilizationPercent, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

class _TriangleDownPainter extends CustomPainter {
  final Color color;

  _TriangleDownPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TriangleDownPainter old) => old.color != color;
}
