import 'dart:async';
import 'package:flutter/material.dart';

/// Per-item like/unlike overlay animation so that only the tapped post animates.
class PostLikeOverlay extends StatefulWidget {
  const PostLikeOverlay({
    super.key,
    this.likedIcon = Icons.favorite_sharp,
    this.unlikedIcon = Icons.heart_broken_outlined,
    required this.likedColor,
    required this.unlikedColor,
    this.iconSize = 120.0,
  });

  final IconData likedIcon;
  final IconData unlikedIcon;
  final Color likedColor;
  final Color unlikedColor;
  final double iconSize;

  @override
  State<PostLikeOverlay> createState() => PostLikeOverlayState();
}

class PostLikeOverlayState extends State<PostLikeOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  // 0 = idle, 1 = play liked, -1 = play unliked
  int _mode = 0;
  Timer? _reverseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
      reverseDuration: const Duration(milliseconds: 440),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut, reverseCurve: Curves.easeOut);
  }

  @override
  void dispose() {
    _reverseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> playLiked() async {
    _play(mode: 1);
  }

  Future<void> playUnliked() async {
    _play(mode: -1);
  }

  void _play({required int mode}) {
    if (!mounted) return;
    _reverseTimer?.cancel();
    setState(() {
      _mode = mode;
    });
    _controller.forward(from: 0.0);
    _reverseTimer = Timer(const Duration(milliseconds: 930), () {
      if (!mounted) return;
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep in the tree; invisible when scale = 0
    final isLikedMode = _mode == 1;
    final color = isLikedMode ? widget.likedColor : widget.unlikedColor;
    final icon = isLikedMode ? widget.likedIcon : widget.unlikedIcon;

    return IgnorePointer(
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Icon(
            icon,
            color: color,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}
