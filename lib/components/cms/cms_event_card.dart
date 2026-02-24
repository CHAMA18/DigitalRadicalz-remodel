import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_theme.dart';
import 'package:digital_radicalz/backend/cms/cms_models.dart';

/// Event card widget for displaying CMS events
class CmsEventCard extends StatelessWidget {
  final CmsEvent event;
  final VoidCallback? onTap;
  final double? width;
  final bool isCompact;
  final bool showTicketInfo;

  const CmsEventCard({
    super.key,
    required this.event,
    this.onTap,
    this.width,
    this.isCompact = false,
    this.showTicketInfo = true,
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
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: event.image != null && event.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: event.image!,
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
                                Icons.event,
                                size: 48,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          )
                        : Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.event,
                              size: 48,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                  ),
                ),
                // Date badge
                if (event.date != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('dd').format(event.date!),
                            style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(event.date!).toUpperCase(),
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Featured badge
                if (event.isFeatured)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
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
            // Event details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (event.category != null && event.category!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.category!,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: FlutterFlowTheme.of(context).primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  // Title
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Time
                  if (event.startTime != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text('${event.startTime}${event.endTime != null ? ' - ${event.endTime}' : ''}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  // Venue
                  if (event.venue != null && event.venue!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.venue!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Ticket info
                  if (showTicketInfo && event.ticketsAvailable) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (event.ticketPrice != null)
                          Text('R${event.ticketPrice!.toStringAsFixed(0)}',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          )
                        else
                          Text('Free',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: Colors.green,
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Get Tickets',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
            // Date box
            if (event.date != null)
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd').format(event.date!),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(event.date!).toUpperCase(),
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Thumbnail fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: event.image != null && event.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: event.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.event,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24,
                            ),
                          ),
                        )
                      : Container(
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Icon(
                            Icons.event,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 24,
                          ),
                        ),
                ),
              ),
            const SizedBox(width: 12),
            // Event info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (event.venue != null && event.venue!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            event.venue!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (event.startTime != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          event.startTime!,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Chevron
            Icon(
              Icons.chevron_right,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ],
        ),
      ),
    );
  }
}
