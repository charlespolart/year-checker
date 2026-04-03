import 'package:flutter/material.dart';

/// A text widget that scrolls horizontally when the text overflows.
class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  bool _overflows = false;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  void didUpdateWidget(covariant MarqueeText old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
    }
  }

  void _checkOverflow() {
    if (!_scrollController.hasClients) return;
    final overflows = _scrollController.position.maxScrollExtent > 0;
    if (overflows != _overflows) {
      setState(() => _overflows = overflows);
      if (overflows && !_animating) {
        _startAnimation();
      }
    }
  }

  Future<void> _startAnimation() async {
    _animating = true;
    await Future.delayed(const Duration(seconds: 2));
    while (mounted && _overflows && _scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      // Scroll to end
      await _scrollController.animateTo(
        max,
        duration: Duration(milliseconds: (max * 50).toInt().clamp(1500, 6000)),
        curve: Curves.linear,
      );
      if (!mounted) break;
      await Future.delayed(const Duration(seconds: 3));
      // Scroll back to start
      if (!mounted || !_scrollController.hasClients) break;
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );
      if (!mounted) break;
      await Future.delayed(const Duration(seconds: 4));
    }
    _animating = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}
