import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'editprofiles_widget.dart' show EditprofilesWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditprofilesModel extends FlutterFlowModel<EditprofilesWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataI74 = false;
  FFUploadedFile uploadedLocalFile_uploadDataI74 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  // State field(s) for passwordchange widget.
  FocusNode? passwordchangeFocusNode;
  TextEditingController? passwordchangeTextController;
  late bool passwordchangeVisibility;
  String? Function(BuildContext, String?)?
      passwordchangeTextControllerValidator;
  // State field(s) for emailchange widget.
  FocusNode? emailchangeFocusNode;
  TextEditingController? emailchangeTextController;
  String? Function(BuildContext, String?)? emailchangeTextControllerValidator;
  // State field(s) for streetchange widget.
  FocusNode? streetchangeFocusNode;
  TextEditingController? streetchangeTextController;
  String? Function(BuildContext, String?)? streetchangeTextControllerValidator;
  // State field(s) for numberstreet widget.
  FocusNode? numberstreetFocusNode;
  TextEditingController? numberstreetTextController;
  String? Function(BuildContext, String?)? numberstreetTextControllerValidator;
  // State field(s) for townname widget.
  FocusNode? townnameFocusNode;
  TextEditingController? townnameTextController;
  String? Function(BuildContext, String?)? townnameTextControllerValidator;
  // State field(s) for Birthday widget.
  FocusNode? birthdayFocusNode;
  TextEditingController? birthdayTextController;
  String? Function(BuildContext, String?)? birthdayTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for Phonnumber widget.
  FocusNode? phonnumberFocusNode;
  TextEditingController? phonnumberTextController;
  String? Function(BuildContext, String?)? phonnumberTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordchangeVisibility = false;
  }

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    passwordchangeFocusNode?.dispose();
    passwordchangeTextController?.dispose();

    emailchangeFocusNode?.dispose();
    emailchangeTextController?.dispose();

    streetchangeFocusNode?.dispose();
    streetchangeTextController?.dispose();

    numberstreetFocusNode?.dispose();
    numberstreetTextController?.dispose();

    townnameFocusNode?.dispose();
    townnameTextController?.dispose();

    birthdayFocusNode?.dispose();
    birthdayTextController?.dispose();

    phonnumberFocusNode?.dispose();
    phonnumberTextController?.dispose();
  }
}
