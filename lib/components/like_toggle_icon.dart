import 'package:flutter/material.dart';

/// A reusable like toggle icon without built-in pulse animation.
/// The visual overlay animation is triggered by the parent widget.
class LikeToggleIcon extends StatelessWidget {
  final bool isLiked;
  final Future<void> Function() onTap;
  final double size;
  final Color likedColor;
  final Color unlikedColor;

  const LikeToggleIcon({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.size = 24.0,
    required this.likedColor,
    required this.unlikedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await onTap();
      },
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? likedColor : unlikedColor,
        size: size,
      ),
    );
  }
}
