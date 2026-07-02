import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wraps a section so it fades and slides up the first time it scrolls
/// into view, instead of the page feeling static. Each instance needs a
/// unique, *stable* [id] (used as the VisibilityDetector key) — reusing
/// the widget's runtimeType alone would collide if a page has several
/// sections of the same widget type.
class ScrollFadeIn extends StatefulWidget {
  const ScrollFadeIn({
    super.key,
    required this.id,
    required this.child,
    this.slideOffset = 0.06,
    this.duration = const Duration(milliseconds: 700),
    this.visibleThreshold = 0.12,
  });

  final String id;
  final Widget child;
  final double slideOffset;
  final Duration duration;
  final double visibleThreshold;

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('scroll-fade-in-${widget.id}'),
      onVisibilityChanged: (info) {
        if (!_visible && info.visibleFraction >= widget.visibleThreshold) {
          setState(() => _visible = true);
        }
      },
      child: AnimatedSlide(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : Offset(0, widget.slideOffset),
        child: AnimatedOpacity(
          duration: widget.duration,
          curve: Curves.easeOut,
          opacity: _visible ? 1 : 0,
          child: widget.child,
        ),
      ),
    );
  }
}
