import 'package:digital_radicalz/flutter_flow/flutter_flow_util.dart';
import 'package:digital_radicalz/components/navbar/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'cms_content_widget.dart' show CmsContentWidget;

class CmsContentModel extends FlutterFlowModel<CmsContentWidget> {
  /// State fields for stateful widgets in this page.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    navbarModel.dispose();
  }
}
