import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/cubit/home_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreditScoreChart extends StatefulWidget {
  const CreditScoreChart({super.key});

  @override
  State<CreditScoreChart> createState() => _CreditScoreChartState();
}

class _CreditScoreChartState extends State<CreditScoreChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CreditScoreChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataPoints = context.select((HomeCubit cubit) => cubit.state.history);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Compute how many points to show based on animation value
        final count = (dataPoints.length * _animation.value)
            .clamp(1, dataPoints.length)
            .toInt();
        final spots = dataPoints
            .sublist(0, count)
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList();
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildChart(spots),
                const SizedBox(height: 16),
                // Footer
                Text(
                  'Last 12 months',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Score calculated using VantageScore 3.0',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Credit Score",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 20,
                      width: 50,
                      decoration: BoxDecoration(
                        color: secondaryGreen,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "+2pts",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Updated Today • Next May 12',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Experian',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: primaryPurpleLight),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart(List<FlSpot> spots) {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.shade300, strokeWidth: 1),
            horizontalInterval: 50,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 50,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: Theme.of(context).colorScheme.secondary,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: Theme.of(context).colorScheme.secondary,
                  );
                },
              ),
            ),
          ],
          minY: 600,
          maxY: 700,
          lineTouchData: LineTouchData(enabled: false),
        ),
      ),
    );
  }
}
