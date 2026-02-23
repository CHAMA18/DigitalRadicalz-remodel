import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'addmembers_widget.dart' show AddmembersWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';

class AddmembersModel extends FlutterFlowModel<AddmembersWidget> {
  ///  Local state fields for this component.

  List<DocumentReference> useradded = [];
  void addToUseradded(DocumentReference item) => useradded.add(item);
  void removeFromUseradded(DocumentReference item) => useradded.remove(item);
  void removeAtIndexFromUseradded(int index) => useradded.removeAt(index);
  void insertAtIndexInUseradded(int index, DocumentReference item) =>
      useradded.insert(index, item);
  void updateUseraddedAtIndex(
          int index, Function(DocumentReference) updateFn) =>
      useradded[index] = updateFn(useradded[index]);

  bool issearchactive = true;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  List<UsersRecord> simpleSearchResults = [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
