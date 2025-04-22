import 'package:flutter/material.dart';

class AnimatedShadowCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double elevation;
  final double borderRadius;
  final Duration duration;

  const AnimatedShadowCard({
    super.key,
    required this.child,
    required this.glowColor,
    this.elevation = 12,
    this.borderRadius = 16,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedShadowCard> createState() => _AnimatedShadowCardState();
}

class _AnimatedShadowCardState extends State<AnimatedShadowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, _) {
        final glow = widget.glowColor.withOpacity(_glowAnimation.value * .7);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: glow,
                blurRadius: 22 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: Card(
            elevation: widget.elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: widget.child,
          ),
        );
      },
    );

  }
}
