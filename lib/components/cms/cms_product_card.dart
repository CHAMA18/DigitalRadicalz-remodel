import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_theme.dart';
import 'package:digital_radicalz/backend/cms/cms_models.dart';

/// Product card widget for displaying CMS products
class CmsProductCard extends StatelessWidget {
  final CmsProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final double? width;
  final bool showAddToCart;
  final bool isGridItem;

  const CmsProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.width,
    this.showAddToCart = true,
    this.isGridItem = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridItem) {
      return _buildGridCard(context);
    }
    return _buildListCard(context);
  }

  Widget _buildGridCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: SizedBox(
                      width: double.infinity,
                      child: product.image != null && product.image!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.image!,
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
                                  Icons.shopping_bag,
                                  size: 40,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                              ),
                            )
                          : Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                Icons.shopping_bag,
                                size: 40,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                    ),
                  ),
                  // Sale badge
                  if (product.isOnSale)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('-${product.discountPercentage}%',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  // Out of stock overlay
                  if (!product.inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Center(
                          child: Text('Out of Stock',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (product.category != null && product.category!.isNotEmpty)
                    Text(
                      product.category!,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 10,
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Row(
                    children: [
                      Text('R${product.effectivePrice.toStringAsFixed(2)}',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 8),
                        Text('R${product.price.toStringAsFixed(2)}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Rating
                  if (product.rating != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < product.rating!.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text('(${product.reviewCount})',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 10,
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

  Widget _buildListCard(BuildContext context) {
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
            // Product image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: product.image != null && product.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.image!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: FlutterFlowTheme.of(context).alternate,
                              child: Icon(
                                Icons.shopping_bag,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                          )
                        : Container(
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.shopping_bag,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                  ),
                ),
                // Sale badge
                if (product.isOnSale)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('-${product.discountPercentage}%',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.category != null && product.category!.isNotEmpty)
                    Text(
                      product.category!,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 11,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Description snippet
                  if (product.description != null && product.description!.isNotEmpty)
                    Text(
                      product.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Price and cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('R${product.effectivePrice.toStringAsFixed(2)}',
                            style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                          if (product.isOnSale)
                            Text('R${product.price.toStringAsFixed(2)}',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                      if (showAddToCart && product.inStock)
                        IconButton(
                          onPressed: onAddToCart,
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (!product.inStock)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Sold Out',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                              color: Colors.white,
                              fontSize: 10,
                            ),
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
}
