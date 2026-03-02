import '/backend/backend.dart';
import '/components/navbar/navbar_widget.dart';
import '/components/main_tab_app_bar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/ff_localization.dart';
import '/components/shimmer_loaders/shimmer_loaders.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shop_model.dart';
export 'shop_model.dart';

class ShopWidget extends StatefulWidget {
  const ShopWidget({super.key});

  static String routeName = 'Shop';
  static String routePath = '/shop';

  @override
  State<ShopWidget> createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget> {
  late ShopModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _matchesSelectedCategory(ProductRecord product, String category) {
    switch (category) {
      case 'Alles':
        return true;
      case 'Stickers':
        return product.category == 'Stickers' || product.category == 'Sticker';
      case 'Assessoires':
        return product.category == 'Assessoires' ||
            product.category == 'Accessoires';
      case 'Scanners':
      case 'Scanner':
        return product.category == 'Scanners';
      default:
        return product.category == category;
    }
  }

  int _visibleProductCount(List<ProductRecord> products) {
    return products
        .where((product) => _matchesSelectedCategory(product, _model.ongenre))
        .length;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShopModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: const MainTabAppBar(showShopActions: true),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 41.0, 0.0, 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 96.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.onselected = 'Scanner';
                                  _model.ongenre = 'Scanners';
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 120.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: (_model.onselected == 'Scanner' ||
                                            _model.onselected == 'Scanners')
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.qr_code_scanner,
                                          color:
                                              (_model.onselected == 'Scanner' ||
                                                      _model.onselected ==
                                                          'Scanners')
                                                  ? Colors.white
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(ffTranslate(context, 'Scanner'),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color: (_model.onselected ==
                                                            'Scanner' ||
                                                        _model.onselected ==
                                                            'Scanners')
                                                    ? Colors.white
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.onselected = 'T-shirt';
                                  _model.ongenre = 'T-shirt';
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 120.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: _model.onselected == 'T-shirt'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.checkroom,
                                          color: _model.onselected == 'T-shirt'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(ffTranslate(context, 'T-shirt'),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color: _model.onselected ==
                                                        'T-shirt'
                                                    ? Colors.white
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.onselected = 'Assessoires';
                                  _model.ongenre = 'Assessoires';
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 120.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: _model.onselected == 'Assessoires'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.watch,
                                          color:
                                              _model.onselected == 'Assessoires'
                                                  ? Colors.white
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(ffTranslate(context, 'Accessoires'),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color: _model.onselected ==
                                                        'Assessoires'
                                                    ? Colors.white
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 12.0, 0.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.onselected = 'Stickers';
                                  _model.ongenre = 'Stickers';
                                  safeSetState(() {});
                                },
                                child: Container(
                                  width: 120.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: _model.onselected == 'Stickers'
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: _model.onselected == 'Stickers'
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(ffTranslate(context, 'Stickers'),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                color: _model.onselected ==
                                                        'Stickers'
                                                    ? Colors.white
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<List<ProductRecord>>(
                              stream: queryProductRecord(),
                              builder: (context, snapshot) {
                                final allProducts = snapshot.data ?? const <ProductRecord>[];
                                final visibleCount =
                                    _visibleProductCount(allProducts);
                                final totalCount = allProducts.length;

                                return Text(
                                  ffTranslate(
                                    context,
                                    '{count} van de {total} producten',
                                    replacements: {
                                      'count': visibleCount.toString(),
                                      'total': totalCount.toString(),
                                    },
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 12.0,
                                        letterSpacing: 0.0,
                                        fontWeight:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontWeight,
                                        fontStyle:
                                            FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                      ),
                                );
                              },
                            ),
                            Text(ffTranslate(context, 'Best verkocht'),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 24.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.ongenre = 'Alles';
                                safeSetState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(ffTranslate(context, 'Alles'),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: valueOrDefault<Color>(
                                            _model.ongenre == 'Alles'
                                                ? Color(0xFF54367D)
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                    child: Divider(
                                      thickness: 2.0,
                                      color: valueOrDefault<Color>(
                                        _model.ongenre == 'Alles'
                                            ? Color(0xFF54367D)
                                            : FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 24.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.ongenre = 'T-shirt';
                                safeSetState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(ffTranslate(context, 'T-shirt'),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: valueOrDefault<Color>(
                                            _model.ongenre == 'T-shirt'
                                                ? Color(0xFF54367D)
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 45.0,
                                    child: Divider(
                                      thickness: 2.0,
                                      color: valueOrDefault<Color>(
                                        _model.ongenre == 'T-shirt'
                                            ? Color(0xFF54367D)
                                            : FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 24.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.ongenre = 'Mokken';
                                safeSetState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(ffTranslate(context, 'Mokken'),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: valueOrDefault<Color>(
                                            _model.ongenre == 'Mokken'
                                                ? Color(0xFF54367D)
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 50.0,
                                    child: Divider(
                                      thickness: 2.0,
                                      color: valueOrDefault<Color>(
                                        _model.ongenre == 'Mokken'
                                            ? Color(0xFF54367D)
                                            : FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 24.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.ongenre = 'Sticker';
                                safeSetState(() {});
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(ffTranslate(context, 'Sticker'),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: valueOrDefault<Color>(
                                            _model.ongenre == 'Sticker'
                                                ? Color(0xFF54367D)
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  SizedBox(
                                    width: 50.0,
                                    child: Divider(
                                      thickness: 2.0,
                                      color: valueOrDefault<Color>(
                                        _model.ongenre == 'Sticker'
                                            ? Color(0xFF54367D)
                                            : FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                        FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.search,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  await showSearch(
                                    context: context,
                                    delegate: ProductSearchDelegate(
                                      selectedCategory: _model.ongenre,
                                      searchLabel: ffTranslate(context, 'Search products'),
                                    ),
                                  );
                                },
                              ),
                              FlutterFlowIconButton(
                                borderRadius: 8.0,
                                buttonSize: 40.0,
                                icon: Icon(
                                  Icons.tune_outlined,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  await showSearch(
                                    context: context,
                                    delegate: ProductFilterDelegate(
                                      selectedCategory: _model.ongenre,
                                      filterByNameLabel: ffTranslate(context, 'Filter by name'),
                                      filterByPriceLabel: ffTranslate(context, 'Filter by price (e.g., 20 or 20-50)'),
                                      mode: ProductFilterMode.price,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (_model.ongenre != 'Alles')
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 12.0, 0.0),
                          child: StreamBuilder<List<ProductRecord>>(
                            stream: (() {
                              if (_model.ongenre == 'Stickers') {
                                return queryProductRecord(
                                  queryBuilder: (p) => p.where('Category',
                                      whereIn: ['Stickers', 'Sticker']),
                                );
                              } else if (_model.ongenre == 'Assessoires') {
                                return queryProductRecord(
                                  queryBuilder: (p) => p.where('Category',
                                      whereIn: ['Assessoires', 'Accessoires']),
                                );
                              } else if (_model.ongenre == 'Scanners' ||
                                  _model.ongenre == 'Scanner') {
                                return queryProductRecord(
                                  queryBuilder: (p) => p.where('Category',
                                      isEqualTo: 'Scanners'),
                                );
                              } else {
                                return queryProductRecord(
                                  queryBuilder: (productRecord) =>
                                      productRecord.where('Category',
                                          isEqualTo: _model.ongenre),
                                );
                              }
                            })(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.error_outline,
                                            size: 48,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText),
                                        SizedBox(height: 8),
                                        Text(ffTranslate(context, 'Kon producten niet laden'),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: FFShimmerLoadingIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<ProductRecord> gridViewProductRecordList =
                                  snapshot.data!;
                              if (gridViewProductRecordList.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(ffTranslate(context, 'Geen producten gevonden'),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium),
                                  ),
                                );
                              }
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 3.0,
                                  childAspectRatio: 0.7,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: gridViewProductRecordList.length,
                                itemBuilder: (context, gridViewIndex) {
                                  final gridViewProductRecord =
                                      gridViewProductRecordList[gridViewIndex];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        ProductDetailWidget.routeName,
                                        queryParameters: {
                                          'productref': serializeParam(
                                            gridViewProductRecord.reference,
                                            ParamType.DocumentReference,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 196.2,
                                          height: 186.9,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  gridViewProductRecord.image,
                                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/bgbbpskgs6os/cf94cb53e76cad106c37181cb4d33c9d1d769357.jpg',
                                                ),
                                              ).image,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                            0.0,
                                            4.0,
                                            0.0,
                                            0.0,
                                          ),
                                          child: Text(
                                            gridViewProductRecord.name,
                                            style: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.fontStyle,
                                                  ),
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.fontStyle,
                                                ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                formatNumber(
                                                  gridViewProductRecord.price,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.periodDecimal,
                                                  currency: '€',
                                                ),
                                                '€50',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                12.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  formatNumber(
                                                    gridViewProductRecord
                                                        .discountprice,
                                                    formatType:
                                                        FormatType.decimal,
                                                    decimalType: DecimalType
                                                        .periodDecimal,
                                                    currency: '€',
                                                  ),
                                                  '€50',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    if (_model.ongenre == 'Alles')
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 12.0, 0.0),
                          child: StreamBuilder<List<ProductRecord>>(
                            stream: queryProductRecord(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.error_outline,
                                            size: 48,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText),
                                        SizedBox(height: 8),
                                        Text(ffTranslate(context, 'Kon producten niet laden'),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: FFShimmerLoadingIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<ProductRecord> gridViewProductRecordList =
                                  snapshot.data!;
                              if (gridViewProductRecordList.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(ffTranslate(context, 'Geen producten gevonden'),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium),
                                  ),
                                );
                              }
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 3.0,
                                  childAspectRatio: 0.7,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: gridViewProductRecordList.length,
                                itemBuilder: (context, gridViewIndex) {
                                  final gridViewProductRecord =
                                      gridViewProductRecordList[gridViewIndex];
                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        ProductDetailWidget.routeName,
                                        queryParameters: {
                                          'productref': serializeParam(
                                            gridViewProductRecord.reference,
                                            ParamType.DocumentReference,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 196.2,
                                          height: 186.9,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.network(
                                                valueOrDefault<String>(
                                                  gridViewProductRecord.image,
                                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/bgbbpskgs6os/cf94cb53e76cad106c37181cb4d33c9d1d769357.jpg',
                                                ),
                                              ).image,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                            0.0,
                                            4.0,
                                            0.0,
                                            0.0,
                                          ),
                                          child: Text(
                                            gridViewProductRecord.name,
                                            style: FlutterFlowTheme.of(
                                              context,
                                            ).bodyMedium.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.fontStyle,
                                                  ),
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.fontStyle,
                                                ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                formatNumber(
                                                  gridViewProductRecord.price,
                                                  formatType:
                                                      FormatType.decimal,
                                                  decimalType:
                                                      DecimalType.periodDecimal,
                                                  currency: '€',
                                                ),
                                                '€50',
                                              ),
                                              style: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.fontStyle,
                                                  ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                12.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  formatNumber(
                                                    gridViewProductRecord
                                                        .discountprice,
                                                    formatType:
                                                        FormatType.decimal,
                                                    decimalType: DecimalType
                                                        .periodDecimal,
                                                    currency: '€',
                                                  ),
                                                  '€50',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navbarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<ProductRecord?> {
  final String selectedCategory;
  final String searchLabel;

  ProductSearchDelegate({required this.selectedCategory, required this.searchLabel});

  @override
  String? get searchFieldLabel => searchLabel;

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResultsList(
      queryText: query,
      selectedCategory: selectedCategory,
      errorText: ffTranslate(context, 'Kon producten niet laden'),
      emptyHintText: ffTranslate(context, 'Type to search products'),
      noResultsText: ffTranslate(context, 'No results for "{query}"', replacements: {'query': query}),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResultsList(
      queryText: query,
      selectedCategory: selectedCategory,
      errorText: ffTranslate(context, 'Kon producten niet laden'),
      emptyHintText: ffTranslate(context, 'Type to search products'),
      noResultsText: ffTranslate(context, 'No results for "{query}"', replacements: {'query': query}),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final String queryText;
  final String selectedCategory;
  final String errorText;
  final String emptyHintText;
  final String noResultsText;

  const _SearchResultsList({
    required this.queryText,
    required this.selectedCategory,
    required this.errorText,
    required this.emptyHintText,
    required this.noResultsText,
  });

  @override
  Widget build(BuildContext context) {
    final String q = queryText.trim().toLowerCase();

    final Stream<List<ProductRecord>> stream = (() {
      if (selectedCategory == 'Alles') {
        return queryProductRecord();
      } else if (selectedCategory == 'Stickers') {
        return queryProductRecord(
          queryBuilder: (p) =>
              p.where('Category', whereIn: ['Stickers', 'Sticker']),
        );
      } else if (selectedCategory == 'Assessoires') {
        return queryProductRecord(
          queryBuilder: (p) =>
              p.where('Category', whereIn: ['Assessoires', 'Accessoires']),
        );
      } else if (selectedCategory == 'Scanners' ||
          selectedCategory == 'Scanner') {
        return queryProductRecord(
          queryBuilder: (p) => p.where('Category', isEqualTo: 'Scanners'),
        );
      } else {
        return queryProductRecord(
          queryBuilder: (p) => p.where('Category', isEqualTo: selectedCategory),
        );
      }
    })();

    return StreamBuilder<List<ProductRecord>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48,
                      color: FlutterFlowTheme.of(context).secondaryText),
                  SizedBox(height: 8),
                  Text(errorText,
                      style: FlutterFlowTheme.of(context).bodyMedium),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: FFShimmerLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        List<ProductRecord> items = snapshot.data!;
        if (q.isNotEmpty) {
          items =
              items.where((p) => (p.name).toLowerCase().contains(q)).toList();
        }

        if (items.isEmpty) {
          return Center(
            child: Text(
              q.isEmpty
                  ? emptyHintText
                  : noResultsText,
              style: FlutterFlowTheme.of(context).labelMedium,
            ),
          );
        }

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          itemBuilder: (context, index) {
            final product = items[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  valueOrDefault<String>(
                    product.image,
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/bgbbpskgs6os/cf94cb53e76cad106c37181cb4d33c9d1d769357.jpg',
                  ),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product.name,
                style: FlutterFlowTheme.of(context).bodyLarge,
              ),
              subtitle: Text(
                valueOrDefault<String>(
                  formatNumber(
                    product.price,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.periodDecimal,
                    currency: '€',
                  ),
                  '€0',
                ),
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              onTap: () {
                // Close search first
                Navigator.of(context).pop();
                // Then navigate to details
                context.pushNamed(
                  ProductDetailWidget.routeName,
                  queryParameters: {
                    'productref': serializeParam(
                      product.reference,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                );
              },
            );
          },
        );
      },
    );
  }
}

enum ProductFilterMode { name, price }

class ProductFilterDelegate extends SearchDelegate<ProductRecord?> {
  final String selectedCategory;
  final String filterByNameLabel;
  final String filterByPriceLabel;
  ProductFilterMode mode;

  ProductFilterDelegate({
    required this.selectedCategory,
    required this.filterByNameLabel,
    required this.filterByPriceLabel,
    this.mode = ProductFilterMode.name,
  });

  @override
  String? get searchFieldLabel => mode == ProductFilterMode.name
      ? filterByNameLabel
      : filterByPriceLabel;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: mode == ProductFilterMode.name
            ? ffTranslate(context, 'Switch to price filter')
            : ffTranslate(context, 'Switch to name filter'),
        icon: Icon(
          mode == ProductFilterMode.name
              ? Icons.attach_money
              : Icons.sort_by_alpha,
        ),
        onPressed: () {
          mode = mode == ProductFilterMode.name
              ? ProductFilterMode.price
              : ProductFilterMode.name;
          showSuggestions(context);
        },
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _FilteredResultsList(
      queryText: query,
      selectedCategory: selectedCategory,
      mode: mode,
      errorText: ffTranslate(context, 'Kon producten niet laden'),
      typeNameHintText: ffTranslate(context, 'Type a product name'),
      typePriceHintText: ffTranslate(context, 'Type a price or range, e.g. 25 or 20-50'),
      noMatchText: ffTranslate(context, 'No products match your filter'),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _FilteredResultsList(
      queryText: query,
      selectedCategory: selectedCategory,
      mode: mode,
      errorText: ffTranslate(context, 'Kon producten niet laden'),
      typeNameHintText: ffTranslate(context, 'Type a product name'),
      typePriceHintText: ffTranslate(context, 'Type a price or range, e.g. 25 or 20-50'),
      noMatchText: ffTranslate(context, 'No products match your filter'),
    );
  }
}

class _FilteredResultsList extends StatelessWidget {
  final String queryText;
  final String selectedCategory;
  final ProductFilterMode mode;
  final String errorText;
  final String typeNameHintText;
  final String typePriceHintText;
  final String noMatchText;

  const _FilteredResultsList({
    required this.queryText,
    required this.selectedCategory,
    required this.mode,
    required this.errorText,
    required this.typeNameHintText,
    required this.typePriceHintText,
    required this.noMatchText,
  });

  (double?, double?, String) _parsePriceRange(String input) {
    // Returns (min, max, mode) where mode is one of: 'range', 'lte', 'gte', 'any'
    final raw = input.trim();
    if (raw.isEmpty) return (null, null, 'any');

    final normalized = raw
        .toLowerCase()
        .replaceAll('eur', '')
        .replaceAll('€', '')
        .replaceAll('\n', ' ');

    // Support operators: >, >=, <, <=
    final opMatch =
        RegExp(r'^(>=|<=|>|<)\s*(\d+(?:[\.,]\d+)?)$').firstMatch(normalized);
    if (opMatch != null) {
      final op = opMatch.group(1)!;
      final numStr = opMatch.group(2)!;
      final val = double.tryParse(numStr.replaceAll(',', '.'));
      if (val != null) {
        if (op == '>' || op == '>=') {
          return (val, null, 'gte');
        } else {
          return (null, val, 'lte');
        }
      }
    }

    // Support ranges: 10-50, 10 – 50, 10 to 50
    final rangeMatch =
        RegExp(r'^(\d+(?:[\.,]\d+)?)\s*(?:-|–|—|to)\s*(\d+(?:[\.,]\d+)?)$')
            .firstMatch(normalized);
    if (rangeMatch != null) {
      final a = double.tryParse(rangeMatch.group(1)!.replaceAll(',', '.'));
      final b = double.tryParse(rangeMatch.group(2)!.replaceAll(',', '.'));
      if (a != null && b != null) {
        final minV = a < b ? a : b;
        final maxV = a < b ? b : a;
        return (minV, maxV, 'range');
      }
    }

    // Fallback: pick first number and interpret as upper bound
    final numMatch = RegExp(r'(\d+(?:[\.,]\d+)?)').firstMatch(normalized);
    if (numMatch != null) {
      final val = double.tryParse(numMatch.group(1)!.replaceAll(',', '.'));
      if (val != null) return (0, val, 'lte');
    }

    return (null, null, 'any');
  }

  @override
  Widget build(BuildContext context) {
    final String q = queryText.trim();

    final Stream<List<ProductRecord>> stream = (() {
      if (selectedCategory == 'Alles') {
        return queryProductRecord();
      } else if (selectedCategory == 'Stickers') {
        return queryProductRecord(
          queryBuilder: (p) =>
              p.where('Category', whereIn: ['Stickers', 'Sticker']),
        );
      } else if (selectedCategory == 'Assessoires') {
        return queryProductRecord(
          queryBuilder: (p) =>
              p.where('Category', whereIn: ['Assessoires', 'Accessoires']),
        );
      } else if (selectedCategory == 'Scanners' ||
          selectedCategory == 'Scanner') {
        return queryProductRecord(
          queryBuilder: (p) => p.where('Category', isEqualTo: 'Scanners'),
        );
      } else {
        return queryProductRecord(
          queryBuilder: (p) => p.where('Category', isEqualTo: selectedCategory),
        );
      }
    })();

    return StreamBuilder<List<ProductRecord>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48,
                      color: FlutterFlowTheme.of(context).secondaryText),
                  SizedBox(height: 8),
                  Text(errorText,
                      style: FlutterFlowTheme.of(context).bodyMedium),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50.0,
              height: 50.0,
              child: FFShimmerLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }
        List<ProductRecord> items = snapshot.data!;

        if (mode == ProductFilterMode.name) {
          final low = q.toLowerCase();
          if (low.isNotEmpty) {
            items = items
                .where((p) => (p.name).toLowerCase().contains(low))
                .toList();
          }
        } else {
          final (minP, maxP, _) = _parsePriceRange(q);
          double effective(ProductRecord p) {
            final hasDisc = p.hasDiscountprice() && p.discountprice > 0;
            if (hasDisc) return p.discountprice;
            return p.hasPrice() ? p.price : 0.0;
          }

          items = items.where((p) {
            final price = effective(p);
            final meetsMin = minP == null ? true : price >= minP;
            final meetsMax = maxP == null ? true : price <= maxP;
            return meetsMin && meetsMax;
          }).toList()
            ..sort((a, b) => effective(a).compareTo(effective(b)));
        }

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                q.isEmpty
                    ? (mode == ProductFilterMode.name
                        ? typeNameHintText
                        : typePriceHintText)
                    : noMatchText,
                style: FlutterFlowTheme.of(context).labelMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          itemBuilder: (context, index) {
            final product = items[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  valueOrDefault<String>(
                    product.image,
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/bgbbpskgs6os/cf94cb53e76cad106c37181cb4d33c9d1d769357.jpg',
                  ),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product.name,
                style: FlutterFlowTheme.of(context).bodyLarge,
              ),
              subtitle: Text(
                valueOrDefault<String>(
                  formatNumber(
                    product.price,
                    formatType: FormatType.decimal,
                    decimalType: DecimalType.periodDecimal,
                    currency: '€',
                  ),
                  '€0',
                ),
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.pushNamed(
                  ProductDetailWidget.routeName,
                  queryParameters: {
                    'productref': serializeParam(
                      product.reference,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                );
              },
            );
          },
        );
      },
    );
  }
}
