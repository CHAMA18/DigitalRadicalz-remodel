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
    final category = _normalizedCategory();
    final title = _normalizedTitle();
    final excerpt = _normalizedExcerpt();
    final body = _normalizedBody(excerpt);
    final publishedDate = news.publishedAt ?? news.createdAt;
    final likes = news.likeCount < 0 ? 0 : news.likeCount;
    final comments = news.commentCount < 0 ? 0 : news.commentCount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 510.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 260.0,
                child: _buildNewsImage(context, showFallbackLabel: true),
              ),
              Expanded(
                child: Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showCategory)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                              category,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color:
                                        FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 13.0,
                                  ),
                            ),
                          ),
                        const SizedBox(height: 12.0),
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: FlutterFlowTheme.of(context).titleLarge.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700),
                                fontSize: 22.0,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          excerpt,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 18.0,
                              ),
                        ),
                        const SizedBox(height: 14.0),
                        Expanded(
                          child: Text(
                            body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  color:
                                      FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 14.0,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              publishedDate != null
                                  ? _formatDate(publishedDate)
                                  : 'No date',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color:
                                        FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 15.0,
                                  ),
                            ),
                            const SizedBox(width: 22.0),
                            Icon(
                              Icons.favorite_border,
                              size: 20.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              '$likes',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color:
                                        FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 15.0,
                                  ),
                            ),
                            const SizedBox(width: 22.0),
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 20.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              '$comments',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color:
                                        FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 15.0,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
    final category = _normalizedCategory();
    final title = _normalizedTitle();
    final excerpt = _normalizedExcerpt();
    final publishedDate = news.publishedAt ?? news.createdAt;

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
                child: _buildNewsImage(context),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    excerpt,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (showCategory) ...[
                        Text(
                          category,
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
                      if (publishedDate != null)
                        Text(
                          _formatDate(publishedDate),
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

  Widget _buildNewsImage(
    BuildContext context, {
    bool showFallbackLabel = false,
  }) {
    final imageUrl = news.featuredImage?.trim();
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
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
        errorWidget: (context, url, error) =>
            _buildImageFallback(context, showFallbackLabel),
      );
    }
    return _buildImageFallback(context, showFallbackLabel);
  }

  Widget _buildImageFallback(BuildContext context, bool showLabel) {
    return Container(
      color: FlutterFlowTheme.of(context).alternate,
      child: Center(
        child: showLabel
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 52,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Image unavailable',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              )
            : Icon(
                Icons.image_not_supported,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24,
              ),
      ),
    );
  }

  String _normalizedCategory() {
    final category = _cleanText(news.category);
    return category.isEmpty ? 'General' : category;
  }

  String _normalizedTitle() {
    final title = _cleanText(news.title);
    return title.isEmpty ? 'Untitled article' : title;
  }

  String _normalizedExcerpt() {
    final excerpt = _cleanText(news.excerpt);
    if (excerpt.isNotEmpty) {
      return excerpt;
    }
    final content = _cleanText(news.content);
    if (content.isEmpty) {
      return 'No summary available';
    }
    return _truncateToWords(content, 12);
  }

  String _normalizedBody(String excerpt) {
    final content = _cleanText(news.content);
    if (content.isEmpty) {
      return 'No content available.';
    }
    var normalized = content;
    if (normalized.toLowerCase().startsWith(excerpt.toLowerCase())) {
      normalized = normalized.substring(excerpt.length).trimLeft();
    }
    if (normalized.isEmpty) {
      return content;
    }
    return normalized;
  }

  String _cleanText(String? value) {
    if (value == null) {
      return '';
    }
    var text = value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', '\'');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text;
  }

  String _truncateToWords(String input, int maxWords) {
    final words = input.split(' ');
    if (words.length <= maxWords) {
      return input;
    }
    return '${words.take(maxWords).join(' ')}...';
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }
}
