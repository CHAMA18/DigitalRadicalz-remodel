import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

/// Lightweight, dependency-free shimmer shims.
///
/// This file intentionally avoids external packages so the app compiles
/// even if shimmer was previously removed. The API mirrors the earlier
/// version so existing usages continue to work, but behavior is a no-op
/// (no actual shimmer animation) to keep things stable.

/// Simple data holder to keep API compatibility with earlier code.
class ShimmerEffect {
  final Color baseColor;
  final Color highlightColor;
  const ShimmerEffect({
    this.baseColor = const Color(0x1F9E9E9E),
    this.highlightColor = const Color(0x0F9E9E9E),
  });
}

/// Scope wrapper that previously enabled shimmer; now it just returns child.
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
    // No-op: simply return child so layout remains unaffected.
    return child;
  }
}

/// Convenient builder that ties shimmer to FFAppState().shimmerEnabled.
class GlobalShimmerWrapper extends StatelessWidget {
  final Widget? child;
  const GlobalShimmerWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    // Keep listening to app state so future re-enables are easy.
    final _ = context.watch<FFAppState>().shimmerEnabled;
    return child ?? const SizedBox();
  }
}

/// A simple box that previously shimmered while loading.
/// Now it renders a static placeholder box when isLoading is true.
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
    // Keep API compatibility: construct effect but do not use it.
    final _ = ShimmerEffect(
      baseColor: baseColor ?? Colors.grey.withValues(alpha: 0.18),
      highlightColor: highlightColor ?? Colors.grey.withValues(alpha: 0.06),
    );

    final box = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: (baseColor ?? Colors.grey.withValues(alpha: 0.18)),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border,
      ),
      child: child,
    );

    // No-op shimmer: when loading, still return the placeholder box.
    // When not loading, also return the box as-is (with child).
    return box;
  }
}

/// Utility: easily toggle shimmer for a subtree without touching state above.
extension ShimmerWidgetX on Widget {
  Widget withShimmer({
    required bool enabled,
    ShimmerEffect? effect,
    Color? containersColor,
  }) {
    // No-op wrapper to keep signatures intact.
    return this;
  }
}
