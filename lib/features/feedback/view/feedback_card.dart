import 'package:ava_take_home/core/colors.dart';
import 'package:flutter/material.dart';

class FeedbackCard extends StatefulWidget {
  final void Function(String feedback) onSubmit;

  const FeedbackCard({super.key, required this.onSubmit});

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();

  static Future<void> showFeedbackSheet({
    required BuildContext context,
    required void Function(String feedback) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(25),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return FeedbackCard(onSubmit: onSubmit);
          },
        );
      },
    );
  }
}

class _FeedbackCardState extends State<FeedbackCard> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  void _handleSend() async {
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    widget.onSubmit(_controller.text);
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16));
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: creamBackground,
          borderRadius: borderRadius,
        ),
        padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      'Give us feedback',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,

                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hint: Text('It’s been very helpful so far!'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withAlpha(15)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black.withAlpha(15)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: textPrimaryDark),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sending ? null : _handleSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _sending
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Send feedback',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
