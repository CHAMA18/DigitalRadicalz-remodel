import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/emptycommunity_widget.dart';
import '/components/main_tab_app_bar.dart';
import '/components/navbar/navbar_widget.dart';
import '/components/shimmer_loaders/shimmer_loaders.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_search/text_search.dart';
import 'community_model.dart';
export 'community_model.dart';

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({super.key});

  static String routeName = 'Community';
  static String routePath = '/community';

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  late CommunityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _performSearch() async {
    final searchText = _model.textController?.text ?? '';
    if (searchText.isEmpty) {
      _model.simpleSearchResults = [];
      safeSetState(() {});
      return;
    }
    await queryCommunitiesRecordOnce()
        .then(
          (records) => _model.simpleSearchResults = TextSearch(
            records
                .map(
                  (record) => TextSearchItem.fromTerms(record, [
                    record.name ?? '',
                    record.subcategory ?? '',
                    record.category ?? '',
                  ]),
                )
                .toList(),
          ).search(searchText).map((r) => r.object).toList(),
        )
        .onError((_, __) => _model.simpleSearchResults = [])
        .whenComplete(() => safeSetState(() {}));
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
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 80.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                onFieldSubmitted: (_) async {
                                  await _performSearch();
                                },
                                onChanged: (value) async {
                                  if (value.isEmpty) {
                                    _model.simpleSearchResults = [];
                                    safeSetState(() {});
                                  } else {
                                    await _performSearch();
                                  }
                                },
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  hintText: ffTranslate(context, 'Search....'),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 24.0,
                                  ),
                                  suffixIcon: (_model.textController?.text.isNotEmpty ?? false)
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            size: 20.0,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                          onPressed: () {
                                            _model.textController?.clear();
                                            _model.simpleSearchResults = [];
                                            safeSetState(() {});
                                          },
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                cursorColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<List<AppPreferenceRecord>>(
                              stream: queryAppPreferenceRecord(
                                singleRecord: true,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return const ShimmerBar(width: 180, height: 22);
                                }
                                List<AppPreferenceRecord>
                                    textAppPreferenceRecordList =
                                    snapshot.data!;
                                final textAppPreferenceRecord =
                                    textAppPreferenceRecordList.isNotEmpty
                                        ? textAppPreferenceRecordList.first
                                        : null;

                                return Text(
                                  valueOrDefault<String>(
                                    textAppPreferenceRecord
                                        ?.recommendedcommunities,
                                    'Recommended communities',
                                  ),
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
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      _model.onbutton = 'Interest';
                                      safeSetState(() {});
                                    },
                                    text: ffTranslate(context, 'Interest'),
                                    options: FFButtonOptions(
                                      width: 108.0,
                                      height: 24.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconAlignment: IconAlignment.end,
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: valueOrDefault<Color>(
                                        _model.onbutton == 'Interest'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : Color(0xFFE1E1E1),
                                        Color(0xFFE1E1E1),
                                      ),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: valueOrDefault<Color>(
                                              _model.onbutton == 'Interest'
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryBackground
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                            ),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      _model.onbutton = 'Purpose';
                                      safeSetState(() {});
                                    },
                                    text: ffTranslate(context, 'Purpose'),
                                    options: FFButtonOptions(
                                      width: 108.0,
                                      height: 24.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconAlignment: IconAlignment.end,
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: valueOrDefault<Color>(
                                        _model.onbutton == 'Purpose'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : Color(0xFFE1E1E1),
                                        Color(0xFFE1E1E1),
                                      ),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: valueOrDefault<Color>(
                                              _model.onbutton == 'Purpose'
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryBackground
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                            ),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      _model.onbutton = 'Role';
                                      safeSetState(() {});
                                    },
                                    text: ffTranslate(context, 'Role'),
                                    options: FFButtonOptions(
                                      width: 108.0,
                                      height: 24.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconAlignment: IconAlignment.end,
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color: valueOrDefault<Color>(
                                        _model.onbutton == 'Role'
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : Color(0xFFE1E1E1),
                                        Color(0xFFE1E1E1),
                                      ),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: valueOrDefault<Color>(
                                              _model.onbutton == 'Role'
                                                  ? FlutterFlowTheme.of(context)
                                                      .secondaryBackground
                                                  : FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                            ),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: StreamBuilder<List<CommunitiesRecord>>(
                                stream: queryCommunitiesRecord(),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: FFShimmerLoadingIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<CommunitiesRecord>
                                      rowCommunitiesRecordList = snapshot.data!;
                                  final selectedFilter =
                                      _model.onbutton.trim().toLowerCase();
                                  final filteredCommunities =
                                      rowCommunitiesRecordList.where((community) {
                                    final normalizedSubcategory =
                                        community.subcategory.trim().toLowerCase();
                                    final normalizedCategory =
                                        community.category.trim().toLowerCase();
                                    return normalizedSubcategory ==
                                            selectedFilter ||
                                        normalizedCategory == selectedFilter;
                                  }).toList();
                                  final recommendedCommunities =
                                      filteredCommunities.isNotEmpty
                                          ? filteredCommunities
                                          : rowCommunitiesRecordList;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: List.generate(
                                          recommendedCommunities.length,
                                          (rowIndex) {
                                        final rowCommunitiesRecord =
                                            recommendedCommunities[rowIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  1.0, 0.0, 12.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                Community2Widget.routeName,
                                                queryParameters: {
                                                  'communityref':
                                                      serializeParam(
                                                    rowCommunitiesRecord
                                                        .reference,
                                                    ParamType.DocumentReference,
                                                  ),
                                                }.withoutNulls,
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                    duration: Duration(
                                                        milliseconds: 0),
                                                  ),
                                                },
                                              );
                                            },
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: 101.8,
                                                  height: 87.1,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: Image.network(
                                                        valueOrDefault<String>(
                                                          rowCommunitiesRecord
                                                              .image,
                                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/1tq3aoud3e8o/aad243aea0b9526193d11bd9c0ab1644f5535407.jpg',
                                                        ),
                                                      ).image,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 8.0, 0.0, 0.0),
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      rowCommunitiesRecord.name,
                                                      'Communities',
                                                    ).maybeHandleOverflow(
                                                      maxChars: 10,
                                                      replacement: '…',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: StreamBuilder<List<AppPreferenceRecord>>(
                                stream: queryAppPreferenceRecord(
                                  singleRecord: true,
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: FFShimmerLoadingIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  List<AppPreferenceRecord>
                                      rowAppPreferenceRecordList =
                                      snapshot.data!;
                                  final rowAppPreferenceRecord =
                                      rowAppPreferenceRecordList.isNotEmpty
                                          ? rowAppPreferenceRecordList.first
                                          : null;

                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        valueOrDefault<String>(
                                          rowAppPreferenceRecord
                                              ?.mijncommunities,
                                          'Mijn communities',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (!loggedIn)
                              Center(
                                child: EmptycommunityWidget(),
                              )
                            else
                              StreamBuilder<List<CommunityMembershipsRecord>>(
                                stream: queryCommunityMembershipsRecord(
                                  queryBuilder: (communityMembershipsRecord) =>
                                      communityMembershipsRecord.where(
                                    'userId',
                                    isEqualTo: currentUserReference,
                                  ),
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: FFShimmerLoadingIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context).primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  final membershipCommunityRefs = snapshot.data!
                                      .where((membership) =>
                                          membership.communityId != null)
                                      .map((membership) => membership.communityId!)
                                      .toSet();

                                  return StreamBuilder<List<CommunitiesRecord>>(
                                    stream: queryCommunitiesRecord(),
                                    builder: (context, communitiesSnapshot) {
                                      if (!communitiesSnapshot.hasData) {
                                        return Center(
                                          child: SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: FFShimmerLoadingIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      final currentUserRef = currentUserReference;
                                      final allCommunities =
                                          communitiesSnapshot.data!;
                                      final myCommunities = allCommunities
                                          .where((community) {
                                            final joinedByCurrentUser =
                                                currentUserRef != null &&
                                                    community.joinedby
                                                        .contains(currentUserRef);
                                            final inMembershipCollection =
                                                membershipCommunityRefs.contains(
                                                    community.reference);
                                            final createdByCurrentUser =
                                                currentUserRef != null &&
                                                    community.createdbyid ==
                                                        currentUserRef;
                                            return joinedByCurrentUser ||
                                                inMembershipCollection ||
                                                createdByCurrentUser;
                                          })
                                          .toList();

                                      if (myCommunities.isEmpty) {
                                        return Center(
                                          child: EmptycommunityWidget(),
                                        );
                                      }

                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: List.generate(myCommunities.length,
                                            (columnIndex) {
                                          final columnCommunitiesRecord =
                                              myCommunities[columnIndex];
                                          return Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0.0, 12.0, 0.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                context.pushNamed(
                                                  Community2Widget.routeName,
                                                  queryParameters: {
                                                    'communityref': serializeParam(
                                                      columnCommunitiesRecord
                                                          .reference,
                                                      ParamType.DocumentReference,
                                                    ),
                                                  }.withoutNulls,
                                                  extra: <String, dynamic>{
                                                    kTransitionInfoKey:
                                                        TransitionInfo(
                                                      hasTransition: true,
                                                      transitionType:
                                                          PageTransitionType.fade,
                                                      duration: Duration(
                                                          milliseconds: 0),
                                                    ),
                                                  },
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .secondaryBackground,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 4.0,
                                                      color: Color(0x33000000),
                                                      offset: Offset(
                                                        0.0,
                                                        2.0,
                                                      ),
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12.0),
                                                ),
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional(0.0, 0.4),
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
                                                          height: 105.0,
                                                          decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: Image.network(
                                                                valueOrDefault<
                                                                    String>(
                                                                  columnCommunitiesRecord
                                                                      .image,
                                                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/d75zc6g7yshz/7373193a9dbc8be8a2cd02a9cdf9f291473d5811.jpg',
                                                                ),
                                                              ).image,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.only(
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      0.0),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      0.0),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      12.0),
                                                              topRight:
                                                                  Radius.circular(
                                                                      12.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: double.infinity,
                                                          height: 43.4,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            borderRadius:
                                                                BorderRadius.only(
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      12.0),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      12.0),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      0.0),
                                                              topRight:
                                                                  Radius.circular(
                                                                      0.0),
                                                            ),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .alternate,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize.max,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    columnCommunitiesRecord
                                                                        .name,
                                                                    '4 mensen bevinden zich in deze community',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(
                                                                                context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            12.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.37),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(32.0, 0.0,
                                                                    32.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 130.5,
                                                              height: 27.4,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xFF1F7A8C),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      columnCommunitiesRecord
                                                                          .category,
                                                                      'Category',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font: GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle: FlutterFlowTheme.of(context)
                                                                                .bodyMedium
                                                                                .fontStyle,
                                                                          ),
                                                                          color: FlutterFlowTheme.of(context)
                                                                              .secondaryBackground,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12.0,
                                                                          0.0,
                                                                          12.0,
                                                                          0.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                32.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              32.0,
                                                                          height:
                                                                              32.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: FlutterFlowTheme.of(context)
                                                                                .secondaryBackground,
                                                                            image:
                                                                                DecorationImage(
                                                                              fit:
                                                                                  BoxFit.cover,
                                                                              image:
                                                                                  Image.asset(
                                                                                'assets/images/9e729cfc2fb3451f2790627112ebba6732cb7a49.jpg',
                                                                              ).image,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                18.0,
                                                                                0.0,
                                                                                20.0,
                                                                                0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              32.0,
                                                                          height:
                                                                              32.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: FlutterFlowTheme.of(context)
                                                                                .secondaryBackground,
                                                                            image:
                                                                                DecorationImage(
                                                                              fit:
                                                                                  BoxFit.cover,
                                                                              image:
                                                                                  Image.asset(
                                                                                'assets/images/a764303deed43df05ca3d05d09059507d646a98c.jpg',
                                                                              ).image,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                48.0,
                                                                                0.0),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              32.0,
                                                                          height:
                                                                              32.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
                                                                              fit:
                                                                                  BoxFit.cover,
                                                                              image:
                                                                                  Image.asset(
                                                                                'assets/images/d12802e9961560961cad4e51a2d1175c20b7c2ed.jpg',
                                                                              ).image,
                                                                            ),
                                                                            shape:
                                                                                BoxShape.circle,
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_model.simpleSearchResults.isNotEmpty ||
                  (_model.textController?.text.isNotEmpty ?? false))
                Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 100.0, 12.0, 80.0),
                  child: _model.simpleSearchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No communities found',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                child: Text(
                                  'Search Results (${_model.simpleSearchResults.length})',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        fontSize: 15.0,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                              ...List.generate(_model.simpleSearchResults.length, (index) {
                                final searchResult = _model.simpleSearchResults[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        Community2Widget.routeName,
                                        queryParameters: {
                                          'communityref': serializeParam(
                                            searchResult.reference,
                                            ParamType.DocumentReference,
                                          ),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 0),
                                          ),
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x33000000),
                                            offset: Offset(0.0, 2.0),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: Stack(
                                        alignment: AlignmentDirectional(0.0, 0.4),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 105.0,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: Image.network(
                                                      valueOrDefault<String>(
                                                        searchResult.image,
                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/d75zc6g7yshz/7373193a9dbc8be8a2cd02a9cdf9f291473d5811.jpg',
                                                      ),
                                                    ).image,
                                                  ),
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(0.0),
                                                    bottomRight: Radius.circular(0.0),
                                                    topLeft: Radius.circular(12.0),
                                                    topRight: Radius.circular(12.0),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 43.4,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(12.0),
                                                    bottomRight: Radius.circular(12.0),
                                                    topLeft: Radius.circular(0.0),
                                                    topRight: Radius.circular(0.0),
                                                  ),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(context).alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          valueOrDefault<String>(
                                                            searchResult.name,
                                                            'Community',
                                                          ),
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                font: GoogleFonts.inter(
                                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                fontSize: 12.0,
                                                                letterSpacing: 0.0,
                                                              ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional(0.0, 0.37),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 130.5,
                                                    height: 27.4,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF1F7A8C),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            valueOrDefault<String>(
                                                              searchResult.category,
                                                              'Category',
                                                            ),
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  font: GoogleFonts.inter(
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                  letterSpacing: 0.0,
                                                                ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
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
