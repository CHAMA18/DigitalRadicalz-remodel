import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_model.dart';

class ConnectTicketAccountModel extends FlutterFlowModel {
  // State field(s) for email TextField.
  TextEditingController? emailController;
  FocusNode? emailFocusNode;
  String? Function(BuildContext, String?)? emailControllerValidator;
  
  // Loading state
  bool isLoading = false;

  String? _emailControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  void initState(BuildContext context) {
    emailControllerValidator = _emailControllerValidator;
  }

  @override
  void dispose() {
    emailController?.dispose();
    emailFocusNode?.dispose();
  }
}
