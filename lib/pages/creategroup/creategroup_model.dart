import '/flutter_flow/flutter_flow_model.dart';
import 'creategroup_widget.dart' show CreateGroupPage;
import 'package:flutter/material.dart';

class CreateGroupPageModel extends FlutterFlowModel<CreateGroupPage> {
  final formKey = GlobalKey<FormState>();

  FocusNode? unfocusNode;
  TextEditingController? titleController;
  TextEditingController? descriptionController;

  String? uploadedImageUrl;
  bool isUploading = false;

  @override
  void initState(BuildContext context) {
    unfocusNode = FocusNode();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    unfocusNode?.dispose();
    titleController?.dispose();
    descriptionController?.dispose();
  }
}