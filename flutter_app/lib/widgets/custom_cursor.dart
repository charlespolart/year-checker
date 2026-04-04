import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/premium_provider.dart';

/// Global animated GIF cursor overlay.
/// Only active when user is authenticated and premium.
class CustomCursorOverlay extends StatefulWidget {
  final Widget child;

  const CustomCursorOverlay({super.key, required this.child});

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay> {
  Offset _position = Offset.zero;
  bool _visible = false;
  Timer? _hideTimer;

  static const _size = 36.0;

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
    final isAuth = context.watch<AuthProvider>().isAuthenticated;
    final canUse = context.watch<PremiumProvider>().canUseAnimatedCursor;
    final active = isAuth && canUse;

    if (!active) return widget.child;

    return Stack(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.none,
          hitTestBehavior: HitTestBehavior.translucent,
          child: widget.child,
        ),
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
