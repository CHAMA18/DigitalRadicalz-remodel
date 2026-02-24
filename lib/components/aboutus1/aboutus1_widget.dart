import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'aboutus1_model.dart';
export 'aboutus1_model.dart';

class Aboutus1Widget extends StatefulWidget {
  const Aboutus1Widget({super.key});

  @override
  State<Aboutus1Widget> createState() => _Aboutus1WidgetState();
}

class _Aboutus1WidgetState extends State<Aboutus1Widget> {
  late Aboutus1Model _model;
  static const String _sectionAbout = 'About Us';
  static const String _sectionTerms = 'Terms and Conditions';
  static const String _sectionPrivacy = 'Privacy Policy';

  static const String _aboutUsContent =
      'DigitalRadicalz is a social and commerce platform built to bring people, communities, creators, and brands into one connected experience. From one account, members can discover communities, join group chats, share media, explore agendas, and access shopping and ticket journeys.\n\n'
      'Our mission is to reduce the gap between discovery and participation. Whether you are joining a conversation, planning your next event, or engaging with community content, the platform is designed to be fast, intuitive, and meaningful.\n\n'
      'We focus on product quality, user safety, and long-term trust. As the platform evolves, we continuously improve moderation, reliability, and user controls so members can participate with confidence across mobile and web.';

  static const String _termsContent = 'Last updated: February 24, 2026\n\n'
      '1) Platform scope\n'
      'DigitalRadicalz provides social and commerce features including community spaces, direct and group messaging, media content, agendas, shopping experiences, and ticket-related services.\n\n'
      '2) Account responsibility\n'
      'You are responsible for your account credentials, profile information, and activity performed through your account. Information you provide should be accurate and kept up to date.\n\n'
      '3) Acceptable use\n'
      'You may not use the platform for unlawful conduct, fraud, harassment, impersonation, abuse, unauthorized access, malware distribution, or any activity that harms others or platform integrity.\n\n'
      '4) Group and community governance\n'
      'Group admins may manage members and settings in their groups. Platform-level safety and moderation standards still apply, and DigitalRadicalz may take action when violations are detected.\n\n'
      '5) Purchases, orders, and tickets\n'
      'When purchasing products or tickets, you agree to the pricing, fees, taxes, and checkout terms displayed at the point of purchase. Availability, delivery, and refund handling may depend on the specific seller or event policy, except where law requires otherwise.\n\n'
      '6) Content and intellectual property\n'
      'You retain rights to content you create. By posting content, you grant DigitalRadicalz a non-exclusive license to host, process, display, and distribute it as needed to operate, secure, and improve the service.\n\n'
      '7) Service changes\n'
      'Features, requirements, and policies may change over time. Continued use of the platform after updates means you accept the revised terms.';

  static const String _privacyContent = 'Last updated: February 24, 2026\n\n'
      'DigitalRadicalz is committed to protecting your privacy. This policy explains what data we collect, why we collect it, and how we protect it.\n\n'
      '1) Information we collect\n'
      'We may collect account details (such as name, email, and profile data), user-generated content, messaging metadata, engagement activity, device and usage diagnostics, and transaction-related records for orders and tickets.\n\n'
      '2) How we use information\n'
      'We use data to provide core functionality, personalize user experience, support community and chat features, process transactions, improve reliability, prevent abuse, and deliver relevant notifications.\n\n'
      '3) Sharing and disclosure\n'
      'We share data only when necessary to run the service, process payments or orders, comply with legal obligations, protect users, or work with trusted infrastructure and service providers under appropriate safeguards.\n\n'
      '4) Data retention\n'
      'We retain data for as long as needed for service delivery, security, legal compliance, and dispute resolution. Retention periods may vary by data type and applicable obligations.\n\n'
      '5) Security\n'
      'We apply technical and organizational safeguards to protect personal information. No system is completely immune to risk, but we continuously improve controls and monitoring.\n\n'
      '6) Your choices and rights\n'
      'You can update profile information and account preferences in the app. Where applicable, you may request access, correction, or deletion of personal data, subject to legal and operational limitations.\n\n'
      '7) Policy updates\n'
      'We may update this policy from time to time. Material changes will be reflected in the updated date and, where appropriate, through in-app notice.';

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Aboutus1Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 11.0, 12.0, 0.0),
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
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        Text('Back',
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        _sectionAbout,
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
                        icon: Icon(
                          Icons.chevron_left,
                          color: Color(0x0014181B),
                          size: 24.0,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                        },
                      ),
                      Text('Back',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: Color(0x0014181B),
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
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                _sectionAbout,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              if (_model.onopen == _sectionAbout)
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: FaIcon(
                                    FontAwesomeIcons.angleDown,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.onopen = null;
                                    safeSetState(() {});
                                  },
                                ),
                              if (_model.onopen != _sectionAbout)
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.onopen = _sectionAbout;
                                    safeSetState(() {});
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_model.onopen == _sectionAbout)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 367.51,
                                decoration: BoxDecoration(),
                                child: Text(
                                  _aboutUsContent,
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
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                _sectionTerms,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              if (_model.onopen == _sectionTerms)
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: FaIcon(
                                    FontAwesomeIcons.angleDown,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.onopen = null;
                                    safeSetState(() {});
                                  },
                                ),
                              if (_model.onopen != _sectionTerms)
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.onopen = _sectionTerms;
                                    safeSetState(() {});
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_model.onopen == _sectionTerms)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 367.51,
                                decoration: BoxDecoration(),
                                child: Text(
                                  _termsContent,
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
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Privacy Policy',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              if (_model.onopen == _sectionPrivacy)
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: FaIcon(
                                    FontAwesomeIcons.angleDown,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.onopen = null;
                                    safeSetState(() {});
                                  },
                                ),
                              if (_model.onopen != _sectionPrivacy)
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    _model.onopen = _sectionPrivacy;
                                    safeSetState(() {});
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_model.onopen == _sectionPrivacy)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 367.51,
                                decoration: BoxDecoration(),
                                child: Text(
                                  _privacyContent,
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
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
