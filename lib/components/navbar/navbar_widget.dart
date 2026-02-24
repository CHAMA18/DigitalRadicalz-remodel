import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navbar_model.dart';
export 'navbar_model.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  late NavbarModel _model;

  Future<void> _navigateToTab(String pageKey, String routeName) async {
    if (FFAppState().onpage == pageKey) return;

    FFAppState().onpage = pageKey;

    if (!mounted) return;
    context.goNamed(
      routeName,
      extra: <String, dynamic>{
        kTransitionInfoKey: TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: Duration(milliseconds: 0),
        ),
      },
    );
  }

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: 58.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Divider(
            height: 0.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).alternate,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await _navigateToTab('Home', HomePageWidget.routeName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      color: valueOrDefault<Color>(
                        FFAppState().onpage == 'Home'
                            ? Color(0xFF1F7A8C)
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primaryText,
                      ),
                      size: 24.0,
                    ),
                    Text('Home',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: valueOrDefault<Color>(
                              FFAppState().onpage == 'Home'
                                  ? Color(0xFF1F7A8C)
                                  : FlutterFlowTheme.of(context).primaryText,
                              FlutterFlowTheme.of(context).primaryText,
                            ),
                            fontSize: 12.0,
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
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await _navigateToTab('Community', CommunityWidget.routeName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      color: valueOrDefault<Color>(
                        FFAppState().onpage == 'Community'
                            ? Color(0xFF1F7A8C)
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primaryText,
                      ),
                      size: 24.0,
                    ),
                    Text('Community',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: valueOrDefault<Color>(
                              FFAppState().onpage == 'Community'
                                  ? Color(0xFF1F7A8C)
                                  : FlutterFlowTheme.of(context).primaryText,
                              FlutterFlowTheme.of(context).primaryText,
                            ),
                            fontSize: 12.0,
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
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await _navigateToTab('Agenda', AgendaoverviewWidget.routeName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      color: valueOrDefault<Color>(
                        FFAppState().onpage == 'Agenda'
                            ? Color(0xFF1F7A8C)
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primaryText,
                      ),
                      size: 24.0,
                    ),
                    Text('Agenda',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: valueOrDefault<Color>(
                              FFAppState().onpage == 'Agenda'
                                  ? Color(0xFF1F7A8C)
                                  : FlutterFlowTheme.of(context).primaryText,
                              FlutterFlowTheme.of(context).primaryText,
                            ),
                            fontSize: 12.0,
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
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await _navigateToTab('Shop', ShopWidget.routeName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: valueOrDefault<Color>(
                        FFAppState().onpage == 'Shop'
                            ? Color(0xFF1F7A8C)
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primaryText,
                      ),
                      size: 24.0,
                    ),
                    Text('Shop',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: valueOrDefault<Color>(
                              FFAppState().onpage == 'Shop'
                                  ? Color(0xFF1F7A8C)
                                  : FlutterFlowTheme.of(context).primaryText,
                              FlutterFlowTheme.of(context).primaryText,
                            ),
                            fontSize: 12.0,
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
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await _navigateToTab('media', MediaWidget.routeName);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outlined,
                      color: valueOrDefault<Color>(
                        FFAppState().onpage == 'media'
                            ? Color(0xFF1F7A8C)
                            : FlutterFlowTheme.of(context).primaryText,
                        FlutterFlowTheme.of(context).primaryText,
                      ),
                      size: 24.0,
                    ),
                    Text('Media',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: valueOrDefault<Color>(
                              FFAppState().onpage == 'media'
                                  ? Color(0xFF1F7A8C)
                                  : FlutterFlowTheme.of(context).primaryText,
                              FlutterFlowTheme.of(context).primaryText,
                            ),
                            fontSize: 12.0,
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
        ],
      ),
    );
  }
}
