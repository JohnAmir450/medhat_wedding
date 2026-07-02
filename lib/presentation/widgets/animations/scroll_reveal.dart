import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wraps a child widget and triggers a smooth fade + slide animation
/// when the widget first becomes visible in the viewport.
///
/// Usage:
/// ```dart
/// ScrollReveal(
///   delay: 200.ms,
///   child: MySection(),
/// )
/// ```
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.duration = 800,
    this.delay = 0,
    this.offset = 0.12,
  });

  final Widget child;

  /// Animation duration in milliseconds.
  final int duration;

  /// Delay before the animation starts, in milliseconds.
  final int delay;

  /// Offset for the slide-up effect (fraction of the widget height).
  final double offset;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _hasBeenRevealed = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offset),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.removeListener(_onScroll);
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      _scrollPosition = scrollable.position;
      _scrollPosition!.addListener(_onScroll);
      // Check initial visibility after the first frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_hasBeenRevealed || !mounted) return;

    final renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final RenderBox box = renderObject as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final viewportHeight = MediaQuery.of(context).size.height;

    // Trigger animation when the widget is within ~120px of the viewport.
    if (position.dy < viewportHeight - 120) {
      _hasBeenRevealed = true;
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Once revealed, show the child fully — no need to keep animating.
        if (_hasBeenRevealed && _controller.isCompleted) {
          return child!;
        }
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: _slide.value * (_fade.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Drop-in replacement that uses flutter_animate for scroll-triggered
/// animations. Simpler but slightly less performant.
class ScrollRevealSimple extends StatefulWidget {
  const ScrollRevealSimple({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ScrollRevealSimple> createState() => _ScrollRevealSimpleState();
}

class _ScrollRevealSimpleState extends State<ScrollRevealSimple> {
  bool _visible = false;
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.removeListener(_onScroll);
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      _scrollPosition = scrollable.position;
      _scrollPosition!.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_visible || !mounted) return;
    final renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;
    final box = renderObject as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final viewportHeight = MediaQuery.of(context).size.height;
    if (position.dy < viewportHeight - 100) {
      setState(() => _visible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _visible
        ? widget.child
            .animate()
            .fadeIn(duration: 700.ms, curve: Curves.easeOut)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic)
        : widget.child;
  }
}
