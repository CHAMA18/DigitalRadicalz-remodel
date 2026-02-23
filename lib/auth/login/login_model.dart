import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  Local state fields for this page.

  String onauth = 'Employer';

  ///  State fields for stateful widgets in this page.

  // State field(s) for Emailemployer widget.
  FocusNode? emailemployerFocusNode;
  TextEditingController? emailemployerTextController;
  String? Function(BuildContext, String?)? emailemployerTextControllerValidator;
  // State field(s) for passwordemployer widget.
  FocusNode? passwordemployerFocusNode;
  TextEditingController? passwordemployerTextController;
  late bool passwordemployerVisibility;
  String? Function(BuildContext, String?)?
      passwordemployerTextControllerValidator;
  // State field(s) for Emailmember widget.
  FocusNode? emailmemberFocusNode;
  TextEditingController? emailmemberTextController;
  String? Function(BuildContext, String?)? emailmemberTextControllerValidator;
  // State field(s) for passwordmember widget.
  FocusNode? passwordmemberFocusNode;
  TextEditingController? passwordmemberTextController;
  late bool passwordmemberVisibility;
  String? Function(BuildContext, String?)?
      passwordmemberTextControllerValidator;
  // State field(s) for displayname widget.
  FocusNode? displaynameFocusNode;
  TextEditingController? displaynameTextController;
  String? Function(BuildContext, String?)? displaynameTextControllerValidator;
  // State field(s) for Createaccountemail widget.
  FocusNode? createaccountemailFocusNode;
  TextEditingController? createaccountemailTextController;
  String? Function(BuildContext, String?)?
      createaccountemailTextControllerValidator;
  // State field(s) for ROLE widget.
  String? roleValue;
  FormFieldController<String>? roleValueController;
  // State field(s) for Createaccountpassword widget.
  FocusNode? createaccountpasswordFocusNode;
  TextEditingController? createaccountpasswordTextController;
  late bool createaccountpasswordVisibility;
  String? Function(BuildContext, String?)?
      createaccountpasswordTextControllerValidator;
  // State field(s) for Createaccountconfirmpassowrd widget.
  FocusNode? createaccountconfirmpassowrdFocusNode;
  TextEditingController? createaccountconfirmpassowrdTextController;
  late bool createaccountconfirmpassowrdVisibility;
  String? Function(BuildContext, String?)?
      createaccountconfirmpassowrdTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordemployerVisibility = false;
    passwordmemberVisibility = false;
    createaccountpasswordVisibility = false;
    createaccountconfirmpassowrdVisibility = false;
  }

  @override
  void dispose() {
    emailemployerFocusNode?.dispose();
    emailemployerTextController?.dispose();

    passwordemployerFocusNode?.dispose();
    passwordemployerTextController?.dispose();

    emailmemberFocusNode?.dispose();
    emailmemberTextController?.dispose();

    passwordmemberFocusNode?.dispose();
    passwordmemberTextController?.dispose();

    displaynameFocusNode?.dispose();
    displaynameTextController?.dispose();

    createaccountemailFocusNode?.dispose();
    createaccountemailTextController?.dispose();

    createaccountpasswordFocusNode?.dispose();
    createaccountpasswordTextController?.dispose();

    createaccountconfirmpassowrdFocusNode?.dispose();
    createaccountconfirmpassowrdTextController?.dispose();
  }
}
