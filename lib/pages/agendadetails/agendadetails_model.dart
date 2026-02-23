import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/event_details/event_details_widget.dart';
import '/components/order/order_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'agendadetails_widget.dart' show AgendadetailsWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AgendadetailsModel extends FlutterFlowModel<AgendadetailsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for EventDetails component.
  late EventDetailsModel eventDetailsModel;

  @override
  void initState(BuildContext context) {
    eventDetailsModel = createModel(context, () => EventDetailsModel());
  }

  @override
  void dispose() {
    eventDetailsModel.dispose();
  }
}
