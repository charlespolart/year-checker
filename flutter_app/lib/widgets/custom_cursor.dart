import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// Global animated GIF cursor overlay.
/// Captures pointer events app-wide (including over dialogs).
class CustomCursorOverlay extends StatefulWidget {
  final Widget child;

  const CustomCursorOverlay({super.key, required this.child});

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay>
    with WidgetsBindingObserver {
  Offset _position = Offset.zero;
  bool _visible = false;
  Timer? _hideTimer;

  static const _size = 32.0;

  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointerEvent);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointerEvent);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _onPointerEvent(PointerEvent event) {
    if (event is PointerHoverEvent ||
        event is PointerMoveEvent ||
        event is PointerDownEvent) {
      setState(() {
        _position = event.position;
        _visible = true;
      });

      _hideTimer?.cancel();
      if (event.kind == PointerDeviceKind.touch) {
        _hideTimer = Timer(const Duration(milliseconds: 800), () {
          if (mounted) setState(() => _visible = false);
        });
      }
    } else if (event is PointerRemovedEvent) {
      setState(() => _visible = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hide system cursor on the entire app
        MouseRegion(
          cursor: SystemMouseCursors.none,
          hitTestBehavior: HitTestBehavior.translucent,
          child: widget.child,
        ),
        // Custom cursor on top of everything
        if (_visible)
          Positioned(
            left: _position.dx - _size / 2,
            top: _position.dy - _size / 2,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/cursor.gif',
                width: _size,
                height: _size,
              ),
            ),
          ),
      ],
    );
  }
}
