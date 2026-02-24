import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/event_details/event_details_widget.dart';
import '/components/order/order_widget.dart';
import '/pages/ticket_completion/ticket_completion_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'agendadetails_model.dart';
export 'agendadetails_model.dart';

class AgendadetailsWidget extends StatefulWidget {
  const AgendadetailsWidget({
    super.key,
    required this.agendaref,
    this.ticketref,
  });

  final DocumentReference? agendaref;
  final DocumentReference?
      ticketref; // Now optional - null means no tickets for this event

  static String routeName = 'Agendadetails';
  static String routePath = '/agendadetails';

  @override
  State<AgendadetailsWidget> createState() => _AgendadetailsWidgetState();
}

class _AgendadetailsWidgetState extends State<AgendadetailsWidget>
    with TickerProviderStateMixin {
  late AgendadetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  // Draggable panel state (for Event details)
  double _panelFraction = 0.22; // current height as fraction of screen height
  final double _minPanelFraction = 0.18;
  final double _maxPanelFraction = 0.98;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AgendadetailsModel());

    animationsMap.addAll({
      'toggleIconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 750.0.ms,
            begin: Offset(0.0, 0.0),
            end: Offset(1.0, 1.0),
          ),
          ScaleEffect(
            curve: Curves.easeOut,
            delay: 930.0.ms,
            duration: 440.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void _snapPanel() {
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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventsRecord>(
      stream: EventsRecord.getDocument(widget!.agendaref!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: FFShimmerLoadingIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final agendadetailsEventsRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: widget.ticketref != null
                ? StreamBuilder<TicketTypesRecord>(
                    stream: TicketTypesRecord.getDocument(widget.ticketref!),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
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

                      final stackTicketTypesRecord = snapshot.data!;

                      return _buildEventContent(
                        context,
                        agendadetailsEventsRecord,
                        stackTicketTypesRecord,
                      );
                    },
                  )
                : _buildEventContent(
                    context,
                    agendadetailsEventsRecord,
                    null, // No ticket data for free events without ticket types
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEventContent(
    BuildContext context,
    EventsRecord agendadetailsEventsRecord,
    TicketTypesRecord? stackTicketTypesRecord,
  ) {
    final bool hasTickets = stackTicketTypesRecord != null;
    final bool isFreeEvent =
        !hasTickets || (stackTicketTypesRecord.price ?? 0) <= 0;
    final panelBottomInset =
        max(MediaQuery.viewPaddingOf(context).bottom, 12.0);
    final ctaBottomSpacing =
        (MediaQuery.sizeOf(context).height * _panelFraction) +
            panelBottomInset +
            16.0;

    return Stack(
      children: [
        // Background content
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: AlignmentDirectional(0.0, 1.1),
                    children: [
                      Container(
                        width: double.infinity,
                        height: 371.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(
                              valueOrDefault<String>(
                                agendadetailsEventsRecord.image,
                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/6x9fccbwamp3/9da0e52c5732baa4906967e2fef26001c0ab7cf1.jpg',
                              ),
                            ).image,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 56.0, 12.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FlutterFlowIconButton(
                                    borderRadius: 100.0,
                                    buttonSize: 40.0,
                                    fillColor: Color(0xFF1F2024),
                                    icon: Icon(
                                      Icons.chevron_left,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      context.safePop();
                                    },
                                  ),
                                  StreamBuilder<List<UsersRecord>>(
                                    stream: queryUsersRecord(
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
                                      List<UsersRecord>
                                          toggleIconUsersRecordList =
                                          snapshot.data!;
                                      // Return an empty Container when the item does not exist.
                                      if (snapshot.data!.isEmpty) {
                                        return Container();
                                      }
                                      final toggleIconUsersRecord =
                                          toggleIconUsersRecordList.isNotEmpty
                                              ? toggleIconUsersRecordList.first
                                              : null;

                                      return ToggleIcon(
                                        onPressed: () async {
                                          final eventlikedElement =
                                              agendadetailsEventsRecord
                                                  .reference;
                                          final eventlikedUpdate =
                                              toggleIconUsersRecord!.eventliked
                                                      .contains(
                                                          eventlikedElement)
                                                  ? FieldValue.arrayRemove(
                                                      [eventlikedElement])
                                                  : FieldValue.arrayUnion(
                                                      [eventlikedElement]);
                                          await toggleIconUsersRecord!.reference
                                              .update({
                                            ...mapToFirestore(
                                              {
                                                'eventliked': eventlikedUpdate,
                                              },
                                            ),
                                          });

                                          await toggleIconUsersRecord!.reference
                                              .update({
                                            ...mapToFirestore(
                                              {
                                                'eventliked':
                                                    FieldValue.arrayUnion([
                                                  agendadetailsEventsRecord
                                                      .reference
                                                ]),
                                              },
                                            ),
                                          });
                                          if (animationsMap[
                                                  'toggleIconOnActionTriggerAnimation'] !=
                                              null) {
                                            await animationsMap[
                                                    'toggleIconOnActionTriggerAnimation']!
                                                .controller
                                                .forward(from: 0.0);
                                          }
                                          HapticFeedback.lightImpact();
                                        },
                                        value: toggleIconUsersRecord!.eventliked
                                            .contains(agendadetailsEventsRecord
                                                .reference),
                                        onIcon: Icon(
                                          Icons.favorite_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          size: 32.0,
                                        ),
                                        offIcon: Icon(
                                          Icons.favorite_border,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 32.0,
                                        ),
                                      ).animateOnActionTrigger(
                                        animationsMap[
                                            'toggleIconOnActionTriggerAnimation']!,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.08),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 2.0, 0.0),
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
                                    Text(
                                      valueOrDefault<String>(
                                        agendadetailsEventsRecord.category,
                                        'Category',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
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
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 32.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            agendadetailsEventsRecord.title,
                            'Free your mind',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
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
                        EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date & Time',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  agendadetailsEventsRecord.startTime,
                                  'Woensdag 11 januari 2023  13.30-15.00',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: valueOrDefault<String>(
                                        agendadetailsEventsRecord.address,
                                        'Nationaal Parklaan, ',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    TextSpan(
                                      text: valueOrDefault<String>(
                                        agendadetailsEventsRecord.venue,
                                        '13650  Dilsen-Stokkem',
                                      ),
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price section - only show if there are tickets
                  if (hasTickets)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 24.0, 12.0, 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isFreeEvent ? Icons.celebration : Icons.euro,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price',
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
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  isFreeEvent
                                      ? 'Free Event'
                                      : valueOrDefault<String>(
                                          formatNumber(
                                            stackTicketTypesRecord?.price,
                                            formatType: FormatType.decimal,
                                            decimalType:
                                                DecimalType.periodDecimal,
                                            currency: '€ ',
                                          ),
                                          '€ 0.00',
                                        ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Free event section - show when no tickets configured
                  if (!hasTickets)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          12.0, 24.0, 12.0, 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.celebration,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Entry',
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
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text('Free Event - No ticket required',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        12.0, 0.0, 12.0, ctaBottomSpacing),
                    child: FFButtonWidget(
                      onPressed: () async {
                        // For events without tickets, register directly
                        if (!hasTickets) {
                          // Create a registration record for the free event
                          await TicketsRecord.collection.doc().set(
                                createTicketsRecordData(
                                  userId: currentUserReference,
                                  eventId: agendadetailsEventsRecord.reference,
                                  status: 'registered',
                                  qrCode: currentJwtToken,
                                  purchaseDate: getCurrentTimestamp,
                                  createdAt: getCurrentTimestamp,
                                ),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully registered for the event!',
                                style: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 3000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                          );
                          context.pushNamed(TicketCompletionWidget.routeName);
                          return;
                        }
                        // For events with tickets, show the order flow
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
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.95,
                                  child: OrderWidget(
                                    agenda: widget.agendaref!,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                      text: isFreeEvent ? 'Register' : 'Get tickets',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ],
              ),
              // Removed the inline EventDetailsWidget here to use the draggable overlay instead.
            ],
          ),
        ),

        // Draggable overlay panel for Event details
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: panelBottomInset,
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * _panelFraction,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                child: Material(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  elevation: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Dedicated drag handle (captures drag; visual handle remains inside content too)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: (details) {
                          final screenH = MediaQuery.sizeOf(context).height;
                          final dy =
                              details.delta.dy; // positive when dragging down
                          final next = (_panelFraction - (dy / screenH))
                              .clamp(_minPanelFraction, _maxPanelFraction);
                          safeSetState(() {
                            _panelFraction = next.toDouble();
                          });
                        },
                        onVerticalDragEnd: (details) => _snapPanel(),
                        child: Semantics(
                          label: ffTranslate(context, 'Drag to resize'),
                          button: true,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            alignment: Alignment.center,
                            child: Container(
                              width: 56,
                              height: 6,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText
                                    .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: wrapWithModel(
                          model: _model.eventDetailsModel,
                          updateCallback: () => safeSetState(() {}),
                          child: EventDetailsWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
