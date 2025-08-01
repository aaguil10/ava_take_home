import 'package:ava_take_home/core/colors.dart';
import 'package:flutter/material.dart';

class NumberCircle extends StatefulWidget {
  final double maxNumber;
  final double number;
  final String label;

  const NumberCircle({
    super.key,
    required this.number,
    required this.label,
    required this.maxNumber,
  });

  @override
  State<NumberCircle> createState() => _NumberCircleState();
}

class _NumberCircleState extends State<NumberCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.number.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(NumberCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldNumber = oldWidget.number;
    final newNumber = widget.number;
    if (oldNumber != newNumber) {
      _animation = Tween<double>(
        begin: oldNumber.toDouble(),
        end: newNumber.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
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
                  value: _animation.value / widget.maxNumber,
                  // normalize to max score
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
                      _animation.value > 1
                          ? _animation.value.toInt().toString()
                          : '${(_animation.value * 100).toStringAsFixed(0)}%',
                      // Closest font I could find to "At Slam Cnd"
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
