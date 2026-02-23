import '/backend/backend.dart';
import '/components/agenda_widget.dart';
import '/components/angenda2_widget.dart';
import '/components/navbar/navbar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'agendaoverview_widget.dart' show AgendaoverviewWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgendaoverviewModel extends FlutterFlowModel<AgendaoverviewWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for agenda component.
  late AgendaModel agendaModel;
  // Model for Navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    agendaModel = createModel(context, () => AgendaModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    agendaModel.dispose();
    navbarModel.dispose();
  }
}
