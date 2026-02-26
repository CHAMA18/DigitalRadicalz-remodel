import 'package:flutter/material.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_model.dart';
import 'comments_page_widget.dart' show CommentsPageWidget;

class CommentsPageModel extends FlutterFlowModel<CommentsPageWidget> {
  /// State fields for stateful widgets in this page.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
