import '/auth/firebase_auth/auth_util.dart';
import '/components/create_group_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'emptyuser_model.dart';
export 'emptyuser_model.dart';

class EmptyuserWidget extends StatefulWidget {
  const EmptyuserWidget({super.key});

  @override
  State<EmptyuserWidget> createState() => _EmptyuserWidgetState();
}

class _EmptyuserWidgetState extends State<EmptyuserWidget> {
  late EmptyuserModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyuserModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Lottie.asset(
            'assets/jsons/Animation_-_1739883113890.json',
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.contain,
            animate: true,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 0.0),
            child: Text('Looks like there are no new users to chat with at the moment. Try to  invite a friend to chat',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          if (valueOrDefault(currentUserDocument?.userType, '') == 'Employee')
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
                child: AuthUserStreamWidget(
                  builder: (context) => FFButtonWidget(
                    onPressed: () async {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height * 0.8,
                              child: CreateGroupWidget(),
                            ),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    text: ffTranslate(context, 'Create Group'),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
