import 'package:ava_take_home/core/colors.dart';
import 'package:ava_take_home/features/home/models/credit_score.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditScoreCard extends StatefulWidget {
  final List<CreditScore> history;

  const CreditScoreCard({super.key, required this.history});

  @override
  State<CreditScoreCard> createState() => _CreditScoreCardState();
}

class _CreditScoreCardState extends State<CreditScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int score;
  late String label;
  late int delta;

  @override
  void initState() {
    super.initState();
    score = widget.history.last.value;
    label = widget.history.last.label;
    if (widget.history.length >= 2) {
      delta =
          widget.history.last.value -
          widget.history[widget.history.length - 2].value;
    } else {
      delta = 0;
    }

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: score.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(CreditScoreCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldScore = oldWidget.history.last.value;
    final newScore = widget.history.last.value;
    if (oldScore != newScore) {
      _animation = Tween<double>(
        begin: oldScore.toDouble(),
        end: newScore.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
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
                          children: [_buildTitle(), _buildSub()],
                        ),
                        _buildExperian(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 50),
                  _buildCreditCircle(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
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
                color: delta > 0 ? secondaryGreen : errorRed,
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

  Widget _buildSub() {
    return Text(
      'Updated Today | Next May 12',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildExperian() {
    return Text(
      'Experian',
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: primaryPurpleLight),
    );
  }

  Widget _buildCreditCircle() {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: _animation.value / 850, // normalize to max score
              strokeWidth: 4,
              backgroundColor: secondaryGreenLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                child: Text(
                  _animation.value.toInt().toString(),
                  // Closest font I could find to "At Slam Cnd"
                  style: GoogleFonts.oswald(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    fontSize: 32, // optional override
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
