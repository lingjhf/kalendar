// class ToolbarSwitcherAnimation extends

import 'package:flutter/material.dart';

class SlideTransitionDirection extends AnimatedWidget {
  SlideTransitionDirection({
    super.key,
    required Animation<double> position,
    this.transformHitTests = true,
    required this.child,
    this.direction = AxisDirection.left,
  }) : super(listenable: position) {
    switch (direction) {
      case AxisDirection.up:
        _tween = Tween(begin: const Offset(0, 1), end: const Offset(0, 0));
        break;
      case AxisDirection.right:
        _tween = Tween(begin: const Offset(-1, 0), end: const Offset(0, 0));
        break;
      case AxisDirection.down:
        _tween = Tween(begin: const Offset(0, -1), end: const Offset(0, 0));
        break;
      case AxisDirection.left:
        _tween = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
        break;
    }
  }

  final AxisDirection direction;

  final bool transformHitTests;

  final Widget child;

  late final Tween<Offset> _tween;

  @override
  Widget build(BuildContext context) {
    final position = listenable as Animation<double>;
    Offset offset =
        _tween.chain(CurveTween(curve: Curves.easeOut)).evaluate(position);
    if (position.status == AnimationStatus.reverse) {
      switch (direction) {
        case AxisDirection.up:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.down:
          offset = Offset(offset.dx, -offset.dy);
          break;
        case AxisDirection.left:
          offset = Offset(-offset.dx, offset.dy);
          break;
        case AxisDirection.right:
          offset = Offset(-offset.dx, offset.dy);
          break;
      }
    }

    return FractionalTranslation(
      translation: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class HorizontalAnimation extends StatelessWidget {
  const HorizontalAnimation({
    super.key,
    required this.direction,
    required this.child,
  });

  final AxisDirection direction;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => SlideTransitionDirection(
          position: animation,
          direction: direction,
          child: child,
        ),
        child: child,
      ),
    );
  }
}

class VisibilityAnimation extends StatelessWidget {
  const VisibilityAnimation({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final tween = Tween<double>(begin: 0, end: 1).chain(
          CurveTween(curve: Curves.easeOut),
        );
        return FadeTransition(
          opacity: tween.animate(animation),
          child: child,
        );
      },
      child: child,
    );
  }
}
