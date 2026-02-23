import '/backend/backend.dart';
import '/components/agenda_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/components/profile/profile_widget.dart';
import '/index.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'agendaoverview_model.dart';
export 'agendaoverview_model.dart';

class AgendaoverviewWidget extends StatefulWidget {
  const AgendaoverviewWidget({super.key});

  static String routeName = 'Agendaoverview';
  static String routePath = '/agendaoverview';

  @override
  State<AgendaoverviewWidget> createState() => _AgendaoverviewWidgetState();
}

class _AgendaoverviewWidgetState extends State<AgendaoverviewWidget> {
  late AgendaoverviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Draggable panel state
  double _panelFraction = 0.45; // between min and max
  final double _minPanelFraction = 0.25;
  final double _maxPanelFraction = 0.9;
  double _dragStartFraction = 0.45;
  bool _longPressActive = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AgendaoverviewModel());

    // Bottom sheet disabled on page load as per request.
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 193.91,
                height: 48.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: Image.asset(
                      'assets/images/Digital_radicalz_(1).png',
                    ).image,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.chat_bubble_outline_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(ChatWidget.routeName);
                      },
                    ),
                  ),
                  AuthUserStreamWidget(
                    builder: (context) => InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: Container(
                                  height: MediaQuery.sizeOf(context).height * 0.98,
                                  child: ProfileWidget(),
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(
                              valueOrDefault<String>(
                                currentUserPhoto,
                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                              ),
                            ).image,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Stack(
                alignment: AlignmentDirectional(0.0, -1.0),
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            StreamBuilder<List<EventsRecord>>(
                              stream: queryEventsRecord(
                                queryBuilder: (eventsRecord) => eventsRecord
                                    .orderBy('createdAt', descending: true),
                                singleRecord: true,
                              ),
                              builder: (context, snapshot) {
                                // Customize what your widget looks like when it's loading.
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                List<EventsRecord> containerEventsRecordList =
                                    snapshot.data!;
                                // Return an empty Container when the item does not exist.
                                if (snapshot.data!.isEmpty) {
                                  return Container();
                                }
                                final containerEventsRecord =
                                    containerEventsRecordList.isNotEmpty
                                        ? containerEventsRecordList.first
                                        : null;

                                return Container(
                                  width: double.infinity,
                                  height: 503.57,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.network(
                                        valueOrDefault<String>(
                                          containerEventsRecord?.image,
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/chateagrkt06/6d27745a75a5d875e4f0244eeb7ec23c8b0cc421.jpg',
                                        ),
                                      ).image,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 200.0, 0.0, 40.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            containerEventsRecord?.startTime,
                                            'Friday 13 december 2022',
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
                                                color: Colors.white,
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
                                        ),
                                        Text(
                                          valueOrDefault<String>(
                                            containerEventsRecord?.title,
                                            'Free your mind event',
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
                                                color: Colors.white,
                                                fontSize: 24.0,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 72.0), // keep above navbar
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * _panelFraction,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Material(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            elevation: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Dedicated drag handle area (press & hold here)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onVerticalDragStart: (details) {
                                    _dragStartFraction = _panelFraction;
                                  },
                                  onVerticalDragUpdate: (details) {
                                    final screenH = MediaQuery.sizeOf(context).height;
                                    final dy = details.delta.dy; // positive when dragging down
                                    final next = (_panelFraction - (dy / screenH))
                                        .clamp(_minPanelFraction, _maxPanelFraction);
                                    safeSetState(() {
                                      _panelFraction = next.toDouble();
                                    });
                                  },
                                  onVerticalDragEnd: (details) {
                                    // Snap to nearest stop
                                    final snaps = <double>[_minPanelFraction, 0.5, _maxPanelFraction];
                                    double closest = snaps.first;
                                    double best = (snaps.first - _panelFraction).abs();
                                    for (final s in snaps) {
                                      final d = (s - _panelFraction).abs();
                                      if (d < best) {
                                        best = d;
                                        closest = s;
                                      }
                                    }
                                    safeSetState(() {
                                      _panelFraction = closest;
                                    });
                                  },
                                  child: Semantics(
                                    label: 'Drag handle: drag vertically to resize agenda panel',
                                    button: true,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 14.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context)
                                                  .secondaryText
                                                  .withValues(alpha: 0.35),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.drag_handle, size: 16, color: FlutterFlowTheme.of(context).secondaryText),
                                              SizedBox(width: 4),
                                              Text(
                                                'Hold to resize',
                                                style: FlutterFlowTheme.of(context).labelSmall.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight: FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontWeight,
                                                        fontStyle: FlutterFlowTheme.of(context)
                                                            .labelSmall
                                                            .fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context)
                                                          .secondaryText
                                                          .withValues(alpha: 0.8),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: wrapWithModel(
                                    model: _model.agendaModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: AgendaWidget(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
