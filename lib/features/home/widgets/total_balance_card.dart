import 'dart:math' as math;

import 'package:flutter/material.dart';

class TotalBalanceCard extends StatefulWidget {
  final double totalBalance; // e.g., 8390
  final double totalLimit; // e.g., 200900
  final double utilization; // 0.0 - 1.0 (e.g., 0.04 for 4%)

  const TotalBalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalLimit,
    required this.utilization,
  });

  @override
  State<TotalBalanceCard> createState() => _TotalBalanceCardState();
}

class _TotalBalanceCardState extends State<TotalBalanceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _utilAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _utilAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant TotalBalanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.utilization != widget.utilization) {
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

  String get formattedBalance =>
      '\$${widget.totalBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  String get formattedLimit =>
      '\$${widget.totalLimit.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  String get percentLabel =>
      '${(widget.utilization * 100).toStringAsFixed(0)}%';

  String get rating {
    final percent = widget.utilization * 100;
    if (percent < 10) return 'Excellent';
    if (percent < 30) return 'Good';
    if (percent < 50) return 'Fair';
    if (percent < 75) return 'Poor';
    return 'Bad';
  }

  Color get ratingColor {
    final percent = widget.utilization * 100;
    if (percent < 10) return Colors.green.shade400;
    if (percent < 30) return Colors.lightGreen;
    if (percent < 50) return Colors.orangeAccent;
    if (percent < 75) return Colors.redAccent.shade100;
    return Colors.red.shade200;
  }

  @override
  Widget build(BuildContext context) {
    // segments for 0-9%, 10-29%, 30-49%, 50-74%, >=75%
    final segments = [
      _Segment(rangeLabel: '0-9%', color: const Color(0xFF2E7D5E)), // green
      _Segment(rangeLabel: '10-29%', color: const Color(0xFFFDD7B0)), // peach
      _Segment(rangeLabel: '30-49%', color: const Color(0xFFFDD7B0)),
      _Segment(rangeLabel: '50-74%', color: const Color(0xFFF4A9B0)), // pinkish
      _Segment(rangeLabel: '<75%', color: const Color(0xFFF4A9B0)),
    ];

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
                SizedBox(
                  width: 110,
                  height: 110,
                  child: _Donut(
                    percent: widget.utilization,
                    label: percentLabel,
                    subLabel: rating,
                    accentColor: widget.utilization * 100 < 10
                        ? const Color(0xFF2E7D5E)
                        : ratingColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Bar with legend
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating text (e.g., "Excellent")
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    rating,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D5E),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalWidth = constraints.maxWidth;
                      return SizedBox(
                        height: 40,
                        child: Stack(
                          children: [
                            // base bar segments
                            Positioned.fill(
                              child: Row(
                                children: [
                                  // Exact percentages: 0-9% takes variable width, others fixed for design—
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2E7D5E),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Container(
                                      color: const Color(0xFFFDD7B0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Container(
                                      color: const Color(0xFFF4A9B0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 51,
                                    child: Container(
                                      color: const Color(0xFFF4A9B0),
                                      // last segment gets rounded end
                                      child: const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Indicator tick marks and labels below
                            Positioned(
                              bottom: -6,
                              left: 0,
                              right: 0,
                              child: _buildPercentageLabels(),
                            ),
                            // Overlay of actual utilization line (thin) with animation
                            AnimatedBuilder(
                              animation: _utilAnim,
                              builder: (context, _) {
                                final pos =
                                    (totalWidth * widget.utilization) *
                                    _utilAnim.value;
                                return Positioned(
                                  top: 0,
                                  left: pos - 1.5,
                                  child: Container(
                                    width: 3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D5E),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: formattedBalance,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E7D5E),
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
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildPercentageLabels() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          '0-9%',
          style: TextStyle(
            color: Color(0xFF2E7D5E),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('10-29%', style: TextStyle(color: Colors.black54)),
        Text('30-49%', style: TextStyle(color: Colors.black54)),
        Text('50-74%', style: TextStyle(color: Colors.black54)),
        Text('<75%', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _Donut extends StatelessWidget {
  final double percent; // 0.0-1.0
  final String label; // e.g., "4%"
  final String subLabel; // e.g., "Excellent"
  final Color accentColor;

  const _Donut({
    required this.percent,
    required this.label,
    required this.subLabel,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final double size = 110;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return CustomPaint(
                painter: _DonutPainter(
                  progress: value,
                  accentColor: accentColor,
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              subLabel,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double progress;
  final Color accentColor;

  _DonutPainter({required this.progress, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final backgroundPaint = Paint()
      ..color = Colors.green.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: [accentColor, accentColor.withOpacity(0.3)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // draw progress arc
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      foregroundPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) {
    return old.progress != progress || old.accentColor != accentColor;
  }
}

class _Segment {
  final String rangeLabel;
  final Color color;

  const _Segment({required this.rangeLabel, required this.color});
}
