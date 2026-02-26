import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/components/shimmer_loaders/shimmer_loaders.dart';
import 'dart:ui';
import '/index.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_ticket_model.dart';
export 'my_ticket_model.dart';

class MyTicketWidget extends StatefulWidget {
  const MyTicketWidget({super.key});

  @override
  State<MyTicketWidget> createState() => _MyTicketWidgetState();
}

class _MyTicketWidgetState extends State<MyTicketWidget> {
  late MyTicketModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyTicketModel());
    // Removed automatic deletion of tickets on page open.
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.chevron_left,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Back',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'My Tickets',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  // Spacer on the right to keep title centered
                  const SizedBox(width: 64.0),
                ],
              ),
              Expanded(
                child: StreamBuilder<List<TicketsRecord>>(
                  stream: queryTicketsRecord(
                    queryBuilder: (ticketsRecord) => ticketsRecord
                        .where(
                          'userId',
                          isEqualTo: currentUserReference,
                        )
                        .where(
                          'status',
                          whereIn: ['registered', 'free', 'paid', 'confirmed', 'active'],
                        )
                        .orderBy('purchaseDate', descending: true),
                  ),
                  builder: (context, snapshot) {
                    // Loading
                    if (!snapshot.hasData) {
                      return const TicketsPageShimmer();
                    }
                    final allTickets = snapshot.data!;

                    // Group tickets by eventId so only one card per event shows.
                    final Map<DocumentReference, List<TicketsRecord>> grouped =
                        {};
                    for (final t in allTickets) {
                      final key = t.eventId;
                      if (key == null) continue;
                      grouped.putIfAbsent(key, () => []).add(t);
                    }

                    // Sort groups by latest purchaseDate in group (desc)
                    final groups = grouped.entries.toList()
                      ..sort((a, b) {
                        DateTime? latestA;
                        for (final t in a.value) {
                          if (latestA == null ||
                              (t.purchaseDate != null &&
                                  t.purchaseDate!.isAfter(latestA!))) {
                            latestA = t.purchaseDate;
                          }
                        }
                        DateTime? latestB;
                        for (final t in b.value) {
                          if (latestB == null ||
                              (t.purchaseDate != null &&
                                  t.purchaseDate!.isAfter(latestB!))) {
                            latestB = t.purchaseDate;
                          }
                        }
                        final aMicros = latestA?.microsecondsSinceEpoch ?? 0;
                        final bMicros = latestB?.microsecondsSinceEpoch ?? 0;
                        return bMicros.compareTo(aMicros);
                      });

                    if (allTickets.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 48.0, 0.0, 0.0),
                          child: Text(
                            ffTranslate(context, 'No tickets yet'),
                            style: FlutterFlowTheme.of(context).labelMedium,
                          ),
                        ),
                      );
                    }

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(ffTranslate(
                                          context, 'Delete all tickets?')),
                                      content: Text(
                                          'This will remove all tickets from your list. This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: Text(
                                              ffTranslate(context, 'Cancel')),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: Text(ffTranslate(
                                              context, 'Delete all')),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              if (confirmed != true) return;

                              try {
                                final qs = await FirebaseFirestore.instance
                                    .collection('Tickets')
                                    .where('userId',
                                        isEqualTo: currentUserReference)
                                    .get();
                                const batchSize = 400;
                                for (var i = 0;
                                    i < qs.docs.length;
                                    i += batchSize) {
                                  final slice = qs.docs.sublist(
                                    i,
                                    (i + batchSize) > qs.docs.length
                                        ? qs.docs.length
                                        : (i + batchSize),
                                  );
                                  final batch =
                                      FirebaseFirestore.instance.batch();
                                  for (final d in slice) {
                                    batch.delete(d.reference);
                                  }
                                  await batch.commit();
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(ffTranslate(
                                          context, 'All tickets deleted.')),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${ffTranslate(context, 'Failed to delete tickets')}: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            label: Text(
                              ffTranslate(context, 'Clear all'),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.red,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                        ...List.generate(groups.length, (index) {
                          final entry = groups[index];
                          final eventRef = entry.key;
                          final ticketsForEvent = entry.value;
                          final firstTicket = ticketsForEvent.first;
                          final qty = ticketsForEvent.length;

                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 24.0, 0.0, 0.0),
                            child: StreamBuilder<EventsRecord>(
                              stream: EventsRecord.getDocument(eventRef),
                              builder: (context, snapshot) {
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
                                final rowEventsRecord = snapshot.data!;

                                return Dismissible(
                                  key: ValueKey<String>(eventRef.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  confirmDismiss: (direction) async {
                                    return await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text(ffTranslate(
                                                context, 'Delete one ticket?')),
                                            content: Text(qty > 1
                                                ? 'This will remove 1 of $qty tickets for this event.'
                                                : 'This will remove your only ticket for this event.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx)
                                                        .pop(false),
                                                child: Text(ffTranslate(
                                                    context, 'Cancel')),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(ctx).pop(true),
                                                child: Text(ffTranslate(
                                                    context, 'Delete')),
                                              ),
                                            ],
                                          ),
                                        ) ??
                                        false;
                                  },
                                  onDismissed: (direction) async {
                                    // Delete just one ticket from this event group
                                    try {
                                      await firstTicket.reference.delete();
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${ffTranslate(context, 'Failed to delete ticket')}: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.pushNamed(
                                        AgendadetailsWidget.routeName,
                                        queryParameters: {
                                          'agendaref': serializeParam(
                                            rowEventsRecord.reference,
                                            ParamType.DocumentReference,
                                          ),
                                          'ticketref': serializeParam(
                                            firstTicket.ticketTypeId,
                                            ParamType.DocumentReference,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 63.5,
                                          height: 115.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 10.0,
                                                color: Color(0x33B4B4B4),
                                                offset: Offset(5.0, 8.0),
                                              )
                                            ],
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(16.0),
                                              bottomRight: Radius.circular(0.0),
                                              topLeft: Radius.circular(16.0),
                                              topRight: Radius.circular(0.0),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: 100.0,
                                            height: 115.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.asset(
                                                  'assets/images/Union.png',
                                                ).image,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 10.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  offset:
                                                      const Offset(5.0, 8.0),
                                                )
                                              ],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                bottomRight:
                                                    Radius.circular(12.0),
                                                topLeft: Radius.circular(0.0),
                                                topRight: Radius.circular(12.0),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            rowEventsRecord
                                                                    .title
                                                                    .isNotEmpty
                                                                ? rowEventsRecord
                                                                    .title
                                                                : ffTranslate(
                                                                    context,
                                                                    'Event unavailable',
                                                                  ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      16.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Text(
                                                              rowEventsRecord
                                                                          .date !=
                                                                      null
                                                                  ? dateTimeFormat(
                                                                      "M/d h:mm a",
                                                                      rowEventsRecord
                                                                          .date,
                                                                    )
                                                                  : ffTranslate(
                                                                      context,
                                                                      'Date unavailable',
                                                                    ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 193.69,
                                                            decoration:
                                                                const BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      0.0),
                                                              child: Text(
                                                                (rowEventsRecord
                                                                            .address)
                                                                        .isNotEmpty
                                                                    ? rowEventsRecord
                                                                        .address
                                                                    : ffTranslate(
                                                                        context,
                                                                        'Location unavailable',
                                                                      ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Right section: QR with quantity badge
                                                SizedBox(
                                                  width: 86.0,
                                                  height: 86.0,
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Positioned.fill(
                                                        child: BarcodeWidget(
                                                          data: firstTicket
                                                              .qrCode,
                                                          barcode:
                                                              Barcode.qrCode(),
                                                          width: 200.0,
                                                          height: 200.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          errorBuilder:
                                                              (_context,
                                                                      _error) =>
                                                                  const SizedBox(
                                                            width: 200.0,
                                                            height: 200.0,
                                                          ),
                                                          drawText: true,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: -6,
                                                        top: -6,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                blurRadius: 6,
                                                                color: Color(
                                                                    0x33000000),
                                                                offset: Offset(
                                                                    0, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: Text(
                                                            'x$qty',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
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
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
