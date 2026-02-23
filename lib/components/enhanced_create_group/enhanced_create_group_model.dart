import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'enhanced_create_group_widget.dart' show EnhancedCreateGroupWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnhancedCreateGroupModel extends FlutterFlowModel<EnhancedCreateGroupWidget> {
  ///  Local state fields for this component.

  List<DocumentReference> selectedMembers = [];
  void addToSelectedMembers(DocumentReference item) => selectedMembers.add(item);
  void removeFromSelectedMembers(DocumentReference item) => selectedMembers.remove(item);
  void removeAtIndexFromSelectedMembers(int index) => selectedMembers.removeAt(index);
  void insertAtIndexInSelectedMembers(int index, DocumentReference item) =>
      selectedMembers.insert(index, item);
  void updateSelectedMembersAtIndex(int index, Function(DocumentReference) updateFn) =>
      selectedMembers[index] = updateFn(selectedMembers[index]);

  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile = FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for groupName widget.
  FocusNode? groupNameFocusNode;
  TextEditingController? groupNameController;
  String? Function(BuildContext, String?)? groupNameControllerValidator;
  // State field(s) for groupDescription widget.
  FocusNode? groupDescriptionFocusNode;
  TextEditingController? groupDescriptionController;
  String? Function(BuildContext, String?)? groupDescriptionControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    groupNameFocusNode?.dispose();
    groupNameController?.dispose();

    groupDescriptionFocusNode?.dispose();
    groupDescriptionController?.dispose();
  }
}