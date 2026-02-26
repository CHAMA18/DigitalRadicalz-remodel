import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/auth/firebase_auth/auth_util.dart';

import 'connect_ticket_account_model.dart';
export 'connect_ticket_account_model.dart';

class ConnectTicketAccountWidget extends StatefulWidget {
  const ConnectTicketAccountWidget({super.key});

  static const String routeName = 'ConnectTicketAccount';
  static const String routePath = '/connect-ticket-account';

  @override
  State<ConnectTicketAccountWidget> createState() =>
      _ConnectTicketAccountWidgetState();
}

class _ConnectTicketAccountWidgetState
    extends State<ConnectTicketAccountWidget> {
  late ConnectTicketAccountModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConnectTicketAccountModel());

    _model.emailController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();
    
    // Pre-fill with user's email if available
    final userEmail = currentUserEmail;
    if (userEmail.isNotEmpty) {
      _model.emailController?.text = userEmail;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30.0,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          ffTranslate(context, 'Connect Ticket Account'),
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600,
                ),
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 18.0,
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F7A8C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F7A8C),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: const Icon(
                          Icons.confirmation_number_outlined,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        ffTranslate(context, 'Link Your Ticket Account'),
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FontWeight.w600,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.amber[700],
                            size: 24.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            ffTranslate(context, 'Earn 500 bonus coins!'),
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: Colors.amber[700],
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),

                // Benefits Section
                Text(
                  ffTranslate(context, 'Benefits of Connecting'),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w600,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 16.0),
                _buildBenefitItem(
                  context,
                  Icons.qr_code_scanner,
                  ffTranslate(context, 'Easy Ticket Access'),
                  ffTranslate(context, 'Access all your tickets in one place with quick QR code scanning at events.'),
                ),
                _buildBenefitItem(
                  context,
                  Icons.sync,
                  ffTranslate(context, 'Auto-Sync Purchases'),
                  ffTranslate(context, 'Your ticket purchases will automatically sync across all your devices.'),
                ),
                _buildBenefitItem(
                  context,
                  Icons.notifications_active,
                  ffTranslate(context, 'Event Reminders'),
                  ffTranslate(context, 'Get notified about upcoming events, schedule changes, and exclusive offers.'),
                ),
                _buildBenefitItem(
                  context,
                  Icons.card_giftcard,
                  ffTranslate(context, 'Exclusive Rewards'),
                  ffTranslate(context, 'Earn points on every ticket purchase and redeem them for discounts and merchandise.'),
                ),
                const SizedBox(height: 32.0),

                // Email Input Section
                Text(
                  ffTranslate(context, 'Enter Your Ticket Account Email'),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w600,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  ffTranslate(context, 'We\'ll send a verification code to confirm your ticket account.'),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _model.emailController,
                  focusNode: _model.emailFocusNode,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: ffTranslate(context, 'Email Address'),
                    hintText: ffTranslate(context, 'Enter your ticket account email'),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF1F7A8C),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                      ),
                  validator: _model.emailControllerValidator.asValidator(context),
                ),
                const SizedBox(height: 32.0),

                // Send Code Button
                FFButtonWidget(
                  onPressed: () async {
                    final email = _model.emailController?.text ?? '';
                    if (email.isEmpty || !email.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ffTranslate(context, 'Please enter a valid email address')),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      );
                      return;
                    }
                    
                    setState(() => _model.isLoading = true);
                    
                    // Simulate sending verification code
                    await Future.delayed(const Duration(seconds: 2));
                    
                    setState(() => _model.isLoading = false);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ffTranslate(context, 'Verification code sent to your email!')),
                          backgroundColor: const Color(0xFF1F7A8C),
                        ),
                      );
                    }
                  },
                  text: _model.isLoading 
                      ? ffTranslate(context, 'Sending...') 
                      : ffTranslate(context, 'Send Verification Code'),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: const Color(0xFF1F7A8C),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w600,
                          ),
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Help Text
                Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(ffTranslate(context, 'Need Help?')),
                          content: Text(
                            ffTranslate(context, 'If you don\'t have a ticket account yet, you can create one on our website or purchase tickets directly through this app. Your account will be automatically created with your first purchase.'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                ffTranslate(context, 'Got it'),
                                style: TextStyle(color: const Color(0xFF1F7A8C)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      ffTranslate(context, 'Don\'t have a ticket account?'),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                            color: const Color(0xFF1F7A8C),
                            decoration: TextDecoration.underline,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: const Color(0xFF1F7A8C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1F7A8C),
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
