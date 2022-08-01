import 'package:flutter/material.dart';

/// A page route with fading animation.
class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute(this.builder);
  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  final Widget Function(BuildContext) builder;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);
}
