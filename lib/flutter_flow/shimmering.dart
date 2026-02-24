import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class ShimmerEffect {
  final Color baseColor;
  final Color highlightColor;
  const ShimmerEffect({
    this.baseColor = const Color(0x1F9E9E9E),
    this.highlightColor = const Color(0x0F9E9E9E),
  });
}

class _ShimmerScopeData extends InheritedWidget {
  final bool enabled;
  final ShimmerEffect effect;
  final Color? containersColor;

  const _ShimmerScopeData({
    required this.enabled,
    required this.effect,
    required this.containersColor,
    required super.child,
  });

  static _ShimmerScopeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ShimmerScopeData>();

  @override
  bool updateShouldNotify(_ShimmerScopeData oldWidget) =>
      enabled != oldWidget.enabled ||
      effect.baseColor != oldWidget.effect.baseColor ||
      effect.highlightColor != oldWidget.effect.highlightColor ||
      containersColor != oldWidget.containersColor;
}

class ShimmerScope extends StatelessWidget {
  final bool enabled;
  final Widget child;
  final ShimmerEffect? effect;
  final Color? containersColor;

  const ShimmerScope({
    super.key,
    required this.enabled,
    required this.child,
    this.effect,
    this.containersColor,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerScopeData(
      enabled: enabled,
      effect: effect ?? const ShimmerEffect(),
      containersColor: containersColor,
      child: child,
    );
  }
}

class GlobalShimmerWrapper extends StatelessWidget {
  final Widget? child;
  const GlobalShimmerWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final enabled = context.watch<FFAppState>().shimmerEnabled;
    return ShimmerScope(
      enabled: enabled,
      effect: const ShimmerEffect(
        baseColor: Color(0x1A9E9E9E),
        highlightColor: Color(0x3AFFFFFF),
      ),
      child: child ?? const SizedBox(),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? baseColor;
  final Color? highlightColor;
  final BoxBorder? border;
  final Widget? child;
  final bool isLoading;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
    this.baseColor,
    this.highlightColor,
    this.border,
    this.child,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    final scope = _ShimmerScopeData.maybeOf(context);
    final shimmerEnabled = scope?.enabled ?? true;
    final effectiveBaseColor = scope?.containersColor ??
        baseColor ??
        scope?.effect.baseColor ??
        Colors.grey.withValues(alpha: 0.18);
    final effectiveHighlightColor = highlightColor ??
        scope?.effect.highlightColor ??
        Colors.grey.withValues(alpha: 0.06);

    final box = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBaseColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border,
      ),
      child: child,
    );

    if (!isLoading || !shimmerEnabled) {
      return box;
    }

    return _ShimmerMask(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      child: box,
    );
  }
}

class _ShimmerMask extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerMask({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerMask> createState() => _ShimmerMaskState();
}

class _ShimmerMaskState extends State<_ShimmerMask>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(-1.8 + (t * 2.6), -0.2),
            end: Alignment(-0.2 + (t * 2.6), 0.2),
            colors: [
              widget.baseColor,
              widget.highlightColor,
              widget.baseColor,
            ],
            stops: const [0.1, 0.5, 0.9],
          ).createShader(bounds),
          child: child!,
        );
      },
      child: widget.child,
    );
  }
}

extension ShimmerWidgetX on Widget {
  Widget withShimmer({
    required bool enabled,
    ShimmerEffect? effect,
    Color? containersColor,
  }) {
    return ShimmerScope(
      enabled: enabled,
      effect: effect,
      containersColor: containersColor,
      child: this,
    );
  }
}
