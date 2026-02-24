import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/detail/detail_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'order_model.dart';
export 'order_model.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({
    super.key,
    required this.agenda,
  });

  final DocumentReference? agenda;

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late OrderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrderModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventsRecord>(
      stream: EventsRecord.getDocument(widget!.agenda!),
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

        final containerEventsRecord = snapshot.data!;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12.0, 11.0, 12.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              onPressed: () {
                                // no-op to keep spacing consistent
                              },
                            ),
                            Text('Back',
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
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Order',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Color(0x0014181B),
                              size: 24.0,
                            ),
                            onPressed: () {},
                          ),
                          Text('Back',
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
                                  color: const Color(0x0014181B),
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
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE1E1E1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 120.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0.0),
                                bottomRight: Radius.circular(24.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(24.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 103.0,
                              height: 99.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.network(
                                    valueOrDefault<String>(
                                      containerEventsRecord.image,
                                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/chateagrkt06/6d27745a75a5d875e4f0244eeb7ec23c8b0cc421.jpg',
                                    ),
                                  ).image,
                                ),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Container(
                                width: 179.9,
                                decoration: const BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      valueOrDefault<String>(
                                        containerEventsRecord.title,
                                        'Free your mind',
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
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
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
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.question_mark_sharp,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 20.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
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
                              Container(
                                width: 176.34,
                                decoration: const BoxDecoration(),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      containerEventsRecord.startTime,
                                      'Woensdag 11 januari 2023 13.30-15.00',
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
                        const EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
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
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    containerEventsRecord.venue,
                                    'Nationaal Parklaan 13650  Dilsen-Stokkem',
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: StreamBuilder<List<TicketTypesRecord>>(
                      stream: queryTicketTypesRecord(
                        queryBuilder: (ticketTypesRecord) =>
                            ticketTypesRecord.where(
                          'eventId',
                          isEqualTo: containerEventsRecord.reference,
                        ),
                      ),
                      builder: (context, snapshot) {
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
                        final types = snapshot.data!;
                        final bool isFreeEvent = types.isNotEmpty &&
                            types.every((t) => (t.price <= 0.0) && (t.fee <= 0.0));

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(types.length, (columnIndex) {
                            final columnTicketTypesRecord = types[columnIndex];
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.tickettyperef ==
                                            columnTicketTypesRecord.reference
                                        ? FlutterFlowTheme.of(context).secondary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12.0, 12.0, 12.0, 12.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.tickettyperef =
                                          columnTicketTypesRecord.reference;
                                      safeSetState(() {});
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              valueOrDefault<String>(
                                                columnTicketTypesRecord.name,
                                                'Ticket Name example',
                                              ),
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              0.0, 6.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          formatNumber(
                                                            columnTicketTypesRecord
                                                                .price,
                                                            formatType:
                                                                FormatType
                                                                    .decimal,
                                                            decimalType:
                                                                DecimalType
                                                                    .periodDecimal,
                                                            currency: '€ ',
                                                          ),
                                                          '€ 75,00',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle:
                                                                        FlutterFlowTheme.of(
                                                                                context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              0.0, 6.0, 0.0, 0.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Container(
                                                        width: 202.09,
                                                        decoration:
                                                            const BoxDecoration(),
                                                        child: RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  formatNumber(
                                                                    columnTicketTypesRecord
                                                                        .price,
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .periodDecimal,
                                                                    currency:
                                                                        '€ ',
                                                                  ),
                                                                  '€ 75,00',
                                                                ),
                                                                style: FlutterFlowTheme
                                                                        .of(context)
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
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          12.0,
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
                                                              TextSpan(
                                                                text: ffTranslate(context, ' + '),
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  columnTicketTypesRecord
                                                                      .fee
                                                                      .toString(),
                                                                  '0,83 ',
                                                                ),
                                                                style:
                                                                    const TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text: ffTranslate(context, ' '),
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  columnTicketTypesRecord
                                                                      .feename,
                                                                  ' administration fee',
                                                                ),
                                                                style:
                                                                    const TextStyle(),
                                                              )
                                                            ],
                                                            style:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font:
                                                                          GoogleFonts
                                                                              .inter(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontStyle: FlutterFlowTheme.of(
                                                                                context)
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
                                                ),
                                              ],
                                            ),
                                            // Quantity controls are considered the "cart". Hide them when the event is free.
                                            Offstage(
                                              offstage: isFreeEvent,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FlutterFlowIconButton(
                                                    borderColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    borderRadius: 100.0,
                                                    buttonSize: 32.0,
                                                    icon: Icon(
                                                      Icons.remove_sharp,
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                      size: 16.0,
                                                    ),
                                                    onPressed: () async {
                                                      final currentQty =
                                                          columnTicketTypesRecord
                                                              .quantity;
                                                      if (currentQty <= 0) {
                                                        // If it somehow went negative before, correct it to 0
                                                        if (currentQty < 0) {
                                                          await columnTicketTypesRecord
                                                              .reference
                                                              .update({
                                                            ...mapToFirestore({
                                                                'quantity': 0
                                                              }),
                                                          });
                                                        }
                                                        return;
                                                      }
                                                      await columnTicketTypesRecord
                                                          .reference
                                                          .update({
                                                        ...mapToFirestore(
                                                          {
                                                            'quantity':
                                                                FieldValue.increment(-1),
                                                          },
                                                        ),
                                                      });
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(12.0, 0.0,
                                                                12.0, 0.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        formatNumber(
                                                          columnTicketTypesRecord
                                                                      .quantity <
                                                                  0
                                                              ? 0
                                                              : columnTicketTypesRecord
                                                                  .quantity,
                                                          formatType:
                                                              FormatType.decimal,
                                                          decimalType: DecimalType
                                                              .periodDecimal,
                                                        ),
                                                        '0',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                  fontStyle:
                                                                      FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                ),
                                                                fontSize: 24.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                              ),
                                                    ),
                                                  ),
                                                  FlutterFlowIconButton(
                                                    borderColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    borderRadius: 100.0,
                                                    buttonSize: 32.0,
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                      size: 16.0,
                                                    ),
                                                    onPressed: () async {
                                                      FFAppState()
                                                              .tickettypequantity =
                                                          FFAppState()
                                                                  .tickettypequantity +
                                                              1;
                                                      safeSetState(() {});

                                                      await columnTicketTypesRecord
                                                          .reference
                                                          .update({
                                                        ...mapToFirestore(
                                                          {
                                                            'quantity':
                                                                FieldValue.increment(1),
                                                          },
                                                        ),
                                                      });
                                                      _model.tickettyperef =
                                                          columnTicketTypesRecord
                                                              .reference;
                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  Divider(
                    height: 32.0,
                    thickness: 2.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  // Totals and fee note are part of the cart. Hide entirely when the event is free.
                  StreamBuilder<List<TicketTypesRecord>>(
                    stream: queryTicketTypesRecord(
                      queryBuilder: (ticketTypesRecord) => ticketTypesRecord.where(
                        'eventId',
                        isEqualTo: containerEventsRecord.reference,
                      ),
                    ),
                    builder: (context, snapshot) {
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
                      final types = snapshot.data!;
                      final bool isFreeEvent = types.isNotEmpty &&
                          types.every((t) => (t.price <= 0.0) && (t.fee <= 0.0));
                      if (isFreeEvent) {
                        return const SizedBox.shrink();
                      }

                      double total = 0.0;
                      for (final t in types) {
                        final int qty = t.quantity < 0 ? 0 : t.quantity;
                        final double price = t.price;
                        final double fee = t.fee;
                        total += qty * (price + fee);
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 217.54,
                            decoration: const BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Ticketprijzen zijn exclusief transactie kosten van minimaal 0,50',
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
                                        color:
                                            FlutterFlowTheme.of(context).secondaryText,
                                        fontSize: 12.0,
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
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total',
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
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Text('Tickets',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatNumber(
                                    total,
                                    formatType: FormatType.decimal,
                                    decimalType: DecimalType.periodDecimal,
                                    currency: '€ ',
                                  ),
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
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: StreamBuilder<List<TicketTypesRecord>>(
                      stream: queryTicketTypesRecord(
                        queryBuilder: (ticketTypesRecord) =>
                            ticketTypesRecord.where(
                          'eventId',
                          isEqualTo: containerEventsRecord.reference,
                        ),
                        singleRecord: true,
                      ),
                      builder: (context, snapshot) {
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
                        List<TicketTypesRecord> buttonTicketTypesRecordList =
                            snapshot.data!;
                        if (snapshot.data!.isEmpty) {
                          return Container();
                        }
                        final buttonTicketTypesRecord =
                            buttonTicketTypesRecordList.isNotEmpty
                                ? buttonTicketTypesRecordList.first
                                : null;

                        return FFButtonWidget(
                          onPressed: () async {
                            // Create ticket records before moving to completion
                            final types = buttonTicketTypesRecordList;
                            final bool isFreeEvent = types.isNotEmpty &&
                                types.every((t) => (t.price <= 0.0) && (t.fee <= 0.0));

                            if (isFreeEvent) {
                              // For free events, create a single ticket for the first type
                              final TicketTypesRecord firstType = types.first;
                              await TicketsRecord.collection.doc().set(
                                createTicketsRecordData(
                                  userId: currentUserReference,
                                  eventId: containerEventsRecord.reference,
                                  ticketTypeId: firstType.reference,
                                  status: 'free',
                                  qrCode: currentJwtToken,
                                  purchaseDate: getCurrentTimestamp,
                                  createdAt: getCurrentTimestamp,
                                ),
                              );
                            } else {
                              // For paid events, create one ticket per selected quantity
                              for (final t in types) {
                                final int qty = t.quantity < 0 ? 0 : t.quantity;
                                for (int i = 0; i < qty; i++) {
                                  await TicketsRecord.collection.doc().set(
                                    createTicketsRecordData(
                                      userId: currentUserReference,
                                      eventId: containerEventsRecord.reference,
                                      ticketTypeId: t.reference,
                                      status: 'notpaid',
                                      qrCode: currentJwtToken,
                                      purchaseDate: getCurrentTimestamp,
                                      createdAt: getCurrentTimestamp,
                                    ),
                                  );
                                }
                              }
                            }

                            context.pushNamed(TicketCompletionWidget.routeName);
                          },
                          text: ffTranslate(context, 'Next'),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 40.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
