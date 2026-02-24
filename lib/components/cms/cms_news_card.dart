import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_theme.dart';
import 'package:digital_radicalz/backend/cms/cms_models.dart';

/// News card widget for displaying CMS news items
class CmsNewsCard extends StatelessWidget {
  final CmsNews news;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showCategory;
  final bool isCompact;

  const CmsNewsCard({
    super.key,
    required this.news,
    this.onTap,
    this.width,
    this.height,
    this.showCategory = true,
    this.isCompact = false,
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
        width: width ?? 295.0,
        height: height ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              if (news.featuredImage != null && news.featuredImage!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: news.featuredImage!,
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
                      Icons.image_not_supported,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                )
              else
                Container(
                  color: FlutterFlowTheme.of(context).alternate,
                  child: Icon(
                    Icons.article,
                    size: 48,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showCategory && news.category != null && news.category!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          news.category!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (news.publishedAt != null)
                      Text(
                        _formatDate(news.publishedAt!),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              // Video indicator
              if (news.type == 'video')
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child: news.featuredImage != null && news.featuredImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: news.featuredImage!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Icon(
                            Icons.image_not_supported,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                        ),
                      )
                    : Container(
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.article,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
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
                      if (news.category != null && news.category!.isNotEmpty) ...[
                        Text(
                          news.category!,
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
                      if (news.publishedAt != null)
                        Text(
                          _formatDate(news.publishedAt!),
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
            // Video indicator
            if (news.type == 'video')
              Icon(
                Icons.play_circle_outline,
                color: FlutterFlowTheme.of(context).primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
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
