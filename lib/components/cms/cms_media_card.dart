import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_theme.dart';
import 'package:digital_radicalz/backend/cms/cms_models.dart';

/// Media card widget for displaying CMS media items (videos, audio, etc.)
class CmsMediaCard extends StatelessWidget {
  final CmsMedia media;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool isCompact;
  final bool showStats;

  const CmsMediaCard({
    super.key,
    required this.media,
    this.onTap,
    this.width,
    this.height,
    this.isCompact = false,
    this.showStats = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }

  Widget _buildFullCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: media.thumbnailUrl != null && media.thumbnailUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: media.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Center(
                                child: FFShimmerLoadingIndicator(
                                  strokeWidth: 2,
                                  color: FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                _getMediaIcon(),
                                size: 48,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          )
                        : Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              _getMediaIcon(),
                              size: 48,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  // Play button
                  if (media.type == 'video' || media.type == 'audio')
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          media.type == 'video' ? Icons.play_arrow : Icons.headphones,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  // Duration badge
                  if (media.duration != null && media.duration!.isNotEmpty)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          media.duration!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  // Featured badge
                  if (media.isFeatured)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text('Featured',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    if (media.category != null && media.category!.isNotEmpty)
                      Text(
                        media.category!,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 11,
                        ),
                      ),
                    const SizedBox(height: 4),
                    // Title
                    Expanded(
                      child: Text(
                        media.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Stats
                    if (showStats)
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 14,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatCount(media.viewCount),
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.favorite,
                            size: 14,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatCount(media.likeCount),
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),
                          if (media.publishedAt != null)
                            Text(
                              _formatDate(media.publishedAt!),
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 100,
                    height: 70,
                    child: media.thumbnailUrl != null && media.thumbnailUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: media.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                _getMediaIcon(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24,
                              ),
                            ),
                          )
                        : Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              _getMediaIcon(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                          ),
                  ),
                ),
                // Play button overlay
                if (media.type == 'video' || media.type == 'audio')
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          media.type == 'video' ? Icons.play_arrow : Icons.headphones,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                // Duration
                if (media.duration != null && media.duration!.isNotEmpty)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        media.duration!,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (media.category != null && media.category!.isNotEmpty) ...[
                        Text(
                          media.category!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('•',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Icon(
                        Icons.visibility,
                        size: 12,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(media.viewCount),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMediaIcon() {
    switch (media.type) {
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.headphones;
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      default:
        return Icons.play_circle;
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
