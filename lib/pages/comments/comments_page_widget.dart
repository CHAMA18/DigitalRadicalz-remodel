import 'package:digital_radicalz/auth/firebase_auth/auth_util.dart';
import 'package:digital_radicalz/backend/backend.dart';
import 'package:digital_radicalz/components/empty_commens/empty_commens_widget.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_theme.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_util.dart';
import 'package:digital_radicalz/flutter_flow/timestamp_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'comments_page_model.dart';
export 'comments_page_model.dart';

class CommentsPageWidget extends StatefulWidget {
const CommentsPageWidget({
super.key,
required this.postid,
required this.userid,
});

final DocumentReference? postid;
final DocumentReference? userid;

static const String routeName = 'CommentsPage';
static const String routePath = '/comments';

@override
State<CommentsPageWidget> createState() => _CommentsPageWidgetState();
}

class _CommentsPageWidgetState extends State<CommentsPageWidget> {
late CommentsPageModel _model;
final scaffoldKey = GlobalKey<ScaffoldState>();

@override
void initState() {
super.initState();
_model = createModel(context, () => CommentsPageModel());
_model.textController ??= TextEditingController();
_model.textFieldFocusNode ??= FocusNode();
}

@override
void dispose() {
_model.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: () {
FocusScope.of(context).unfocus();
FocusManager.instance.primaryFocus?.unfocus();
},
child: Scaffold(
key: scaffoldKey,
backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
appBar: AppBar(
backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
automaticallyImplyLeading: false,
leading: FlutterFlowIconButton(
borderRadius: 8.0,
buttonSize: 40.0,
icon: Icon(
Icons.arrow_back,
color: FlutterFlowTheme.of(context).primaryText,
size: 24.0,
),
onPressed: () => context.pop(),
),
title: FutureBuilder<int>(
future: queryCommentsecctionRecordCount(
queryBuilder: (commentsecctionRecord) =>
commentsecctionRecord.where(
'Postid',
isEqualTo: widget.postid,
),
),
builder: (context, snapshot) {
if (!snapshot.hasData) {
return Text(
ffTranslate(context, 'Comments'),
style: FlutterFlowTheme.of(context).headlineMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.bold,
),
fontSize: 18.0,
letterSpacing: 0.0,
),
);
}
int textCount = snapshot.data!;
return InkWell(
splashColor: Colors.transparent,
focusColor: Colors.transparent,
hoverColor: Colors.transparent,
highlightColor: Colors.transparent,
onTap: () async {
await widget.postid!.update(createPostRecordData(
commentcount: textCount.toDouble(),
));
},
child: Text(
'${valueOrDefault<String>(
formatNumber(
textCount,
formatType: FormatType.decimal,
decimalType: DecimalType.periodDecimal,
),
'0',
)} ${ffTranslate(context, 'Comments')}',
style: FlutterFlowTheme.of(context).headlineMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.bold,
),
fontSize: 18.0,
letterSpacing: 0.0,
),
),
);
},
),
centerTitle: true,
elevation: 0.0,
),
body: SafeArea(
top: true,
child: Column(
children: [
Expanded(
child: StreamBuilder<List<CommentsecctionRecord>>(
stream: queryCommentsecctionRecord(
queryBuilder: (commentsecctionRecord) =>
commentsecctionRecord
.where('Postid', isEqualTo: widget.postid),
),
builder: (context, snapshot) {
if (!snapshot.hasData) {
return Center(
child: SizedBox(
width: 50.0,
height: 50.0,
child: FFShimmerLoadingIndicator(
valueColor: AlwaysStoppedAnimation<Color>(
FlutterFlowTheme.of(context).primary,
),
),
),
);
}
var records = List<CommentsecctionRecord>.from(snapshot.data!);
// Client-side sorting to avoid missing index errors
records.sort((a, b) {
if (a.timestamp == null && b.timestamp == null) return 0;
if (a.timestamp == null) return 1;
if (b.timestamp == null) return -1;
return a.timestamp!.compareTo(b.timestamp!);
});
if (records.isEmpty) {
return Center(child: EmptyCommensWidget());
}

return ListView.separated(
padding: EdgeInsets.only(
top: 8.0,
bottom: 16.0,
left: 16.0,
right: 16.0,
),
physics: const AlwaysScrollableScrollPhysics(),
itemCount: records.length,
separatorBuilder: (_, __) => const SizedBox(height: 0),
itemBuilder: (context, index) {
final columnCommentsecctionRecord = records[index];
return Padding(
padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
child: StreamBuilder<UsersRecord>(
stream: UsersRecord.getDocument(
columnCommentsecctionRecord.hasUserid()
? columnCommentsecctionRecord.userid!
: widget.userid!,
),
builder: (context, snapshot) {
if (!snapshot.hasData) {
// Show optimistic UI with comment content while user loads
return Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Expanded(
child: Row(
mainAxisSize: MainAxisSize.max,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
width: 40.0,
height: 40.0,
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).alternate,
shape: BoxShape.circle,
),
),
Expanded(
child: Padding(
padding: EdgeInsetsDirectional
.fromSTEB(10.0, 0.0, 0.0, 0.0),
child: Column(
mainAxisSize: MainAxisSize.max,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
width: 100.0,
height: 12.0,
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).alternate,
borderRadius: BorderRadius.circular(4.0),
),
),
Padding(
padding: EdgeInsetsDirectional
.fromSTEB(
0.0, 4.0, 0.0, 0.0),
child: Text(
columnCommentsecctionRecord
.comment,
style:
FlutterFlowTheme.of(
context)
.bodyMedium
.override(
font: GoogleFonts
.inter(
fontWeight:
FontWeight
.w400,
),
color: FlutterFlowTheme.of(
context)
.primaryText,
fontSize: 14.0,
letterSpacing:
0.0,
),
),
),
],
),
),
),
],
),
),
],
);
}

final rowUsersRecord = snapshot.data!;

return InkWell(
onLongPress: () async {
final isOwner =
columnCommentsecctionRecord.hasUserid() &&
columnCommentsecctionRecord.userid ==
currentUserReference;
if (!isOwner) {
return;
}
final confirm = await showDialog<bool>(
context: context,
builder: (dialogContext) {
return AlertDialog(
title: Text(ffTranslate(
context, 'Delete comment?')),
content: Text(ffTranslate(context,
'This action cannot be undone.')),
actions: [
TextButton(
onPressed: () =>
Navigator.of(dialogContext)
.pop(false),
child: Text(ffTranslate(
context, 'Cancel')),
),
TextButton(
onPressed: () =>
Navigator.of(dialogContext)
.pop(true),
child: Text(ffTranslate(
context, 'Delete')),
),
],
);
},
) ??
false;
if (confirm) {
try {
await columnCommentsecctionRecord.reference
.delete();
if (mounted) {
ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
content: Text(
ffTranslate(
context, 'Comment deleted'),
),
),
);
}
} catch (e) {
if (mounted) {
ScaffoldMessenger.of(context)
.showSnackBar(
SnackBar(
content: Text(
'${ffTranslate(context, 'Failed to delete comment')}: $e',
),
),
);
}
}
}
},
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Expanded(
child: Row(
mainAxisSize: MainAxisSize.max,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
width: 40.0,
height: 40.0,
decoration: BoxDecoration(
image: DecorationImage(
fit: BoxFit.cover,
image: Image.network(
valueOrDefault<String>(
rowUsersRecord.photoUrl,
'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/e495icjzpkwm/upload-or-add-a-picture-jpg-file-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-etc-vector-removebg-preview.png',
),
).image,
),
shape: BoxShape.circle,
),
),
Expanded(
child: Padding(
padding: EdgeInsetsDirectional
.fromSTEB(10.0, 0.0, 0.0, 0.0),
child: Column(
mainAxisSize: MainAxisSize.max,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
mainAxisSize:
MainAxisSize.max,
children: [
Padding(
padding:
EdgeInsetsDirectional
.fromSTEB(
0.0,
0.0,
4.0,
0.0),
child: Text(
rowUsersRecord
.displayName,
style:
FlutterFlowTheme.of(
context)
.bodyMedium
.override(
font: GoogleFonts
.inter(
fontWeight:
FontWeight
.w600,
),
fontSize:
14.0,
letterSpacing:
0.0,
),
),
),
if (columnCommentsecctionRecord
.hasTimestamp() &&
columnCommentsecctionRecord
.timestamp !=
null)
Row(
mainAxisSize:
MainAxisSize.min,
children: [
Padding(
padding:
const EdgeInsets
.symmetric(
horizontal:
4.0),
child: Container(
width: 3.0,
height: 3.0,
decoration:
BoxDecoration(
color: FlutterFlowTheme.of(
context)
.secondaryText
.withValues(
alpha:
0.5),
shape: BoxShape
.circle,
),
),
),
Text(
TimestampFormatter
.formatRelative(
columnCommentsecctionRecord
.timestamp!),
style: FlutterFlowTheme
.of(context)
.bodySmall
.override(
font: GoogleFonts
.inter(
fontWeight:
FontWeight
.w400,
),
color: FlutterFlowTheme.of(
context)
.secondaryText
.withValues(
alpha:
0.7),
fontSize:
11.0,
letterSpacing:
0.0,
),
),
],
),
if (rowUsersRecord
.userType ==
'Super Admin')
Padding(
padding:
EdgeInsetsDirectional
.fromSTEB(
6.0,
0.0,
0.0,
0.0),
child: Text(
valueOrDefault<
String>(
rowUsersRecord
.userType,
'Super Admin',
),
style: FlutterFlowTheme
.of(context)
.bodyMedium
.override(
font:
GoogleFonts
.inter(),
color: FlutterFlowTheme.of(
context)
.warning,
fontSize:
12.0,
letterSpacing:
0.0,
),
),
),
if (rowUsersRecord
.userType ==
'member')
Padding(
padding:
EdgeInsetsDirectional
.fromSTEB(
6.0,
0.0,
0.0,
0.0),
child: Text(
valueOrDefault<
String>(
rowUsersRecord
.userType,
'member',
),
style: FlutterFlowTheme
.of(context)
.bodyMedium
.override(
font:
GoogleFonts
.inter(),
color: FlutterFlowTheme.of(
context)
.secondaryText,
fontSize:
12.0,
letterSpacing:
0.0,
),
),
),
if (rowUsersRecord
.userType ==
'Employee')
Padding(
padding:
EdgeInsetsDirectional
.fromSTEB(
6.0,
0.0,
0.0,
0.0),
child: Text(
valueOrDefault<
String>(
rowUsersRecord
.userType,
'Employee',
),
style: FlutterFlowTheme
.of(context)
.bodyMedium
.override(
font:
GoogleFonts
.inter(),
color: FlutterFlowTheme.of(
context)
.tertiary,
fontSize:
12.0,
letterSpacing:
0.0,
),
),
),
if (rowUsersRecord
.userType ==
'Admin')
Padding(
padding:
EdgeInsetsDirectional
.fromSTEB(
6.0,
0.0,
0.0,
0.0),
child: Text(
valueOrDefault<
String>(
rowUsersRecord
.userType,
'Admin',
),
style: FlutterFlowTheme
.of(context)
.bodyMedium
.override(
font:
GoogleFonts
.inter(),
color: FlutterFlowTheme.of(
context)
.secondary,
fontSize:
12.0,
letterSpacing:
0.0,
),
),
),
],
),
Padding(
padding: EdgeInsetsDirectional
.fromSTEB(
0.0, 4.0, 0.0, 0.0),
child: Text(
columnCommentsecctionRecord
.comment,
style:
FlutterFlowTheme.of(
context)
.bodyMedium
.override(
font: GoogleFonts
.inter(
fontWeight:
FontWeight
.w400,
),
color: FlutterFlowTheme.of(
context)
.primaryText,
fontSize: 14.0,
letterSpacing:
0.0,
),
),
),
],
),
),
),
],
),
),
],
),
);
},
),
);
},
);
},
),
),
Container(
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).secondaryBackground,
boxShadow: [
BoxShadow(
blurRadius: 4,
color: Color(0x10000000),
offset: Offset(0, -2),
),
],
),
child: SafeArea(
top: false,
child: Padding(
padding: EdgeInsetsDirectional.fromSTEB(
16.0,
12.0,
16.0,
MediaQuery.viewInsetsOf(context).bottom + 12.0,
),
child: Row(
mainAxisSize: MainAxisSize.max,
children: [
AuthUserStreamWidget(
builder: (context) => Container(
width: 40.0,
height: 40.0,
decoration: BoxDecoration(
image: DecorationImage(
fit: BoxFit.cover,
image: Image.network(
valueOrDefault<String>(
currentUserPhoto,
'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/e495icjzpkwm/upload-or-add-a-picture-jpg-file-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-etc-vector-removebg-preview.png',
),
).image,
),
shape: BoxShape.circle,
),
),
),
Expanded(
child: Padding(
padding: EdgeInsetsDirectional.fromSTEB(
12.0, 0.0, 12.0, 0.0),
child: TextFormField(
controller: _model.textController,
focusNode: _model.textFieldFocusNode,
autofocus: false,
obscureText: false,
decoration: InputDecoration(
isDense: true,
labelStyle: FlutterFlowTheme.of(context)
.labelMedium
.override(
font: GoogleFonts.inter(),
letterSpacing: 0.0,
),
hintText: ffTranslate(context, 'Add a comment'),
hintStyle: FlutterFlowTheme.of(context)
.labelMedium
.override(
font: GoogleFonts.inter(),
letterSpacing: 0.0,
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(
color:
FlutterFlowTheme.of(context).alternate,
width: 1.0,
),
borderRadius: BorderRadius.circular(24.0),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(
color: FlutterFlowTheme.of(context).primary,
width: 1.0,
),
borderRadius: BorderRadius.circular(24.0),
),
errorBorder: OutlineInputBorder(
borderSide: BorderSide(
color: FlutterFlowTheme.of(context).error,
width: 1.0,
),
borderRadius: BorderRadius.circular(24.0),
),
focusedErrorBorder: OutlineInputBorder(
borderSide: BorderSide(
color: FlutterFlowTheme.of(context).error,
width: 1.0,
),
borderRadius: BorderRadius.circular(24.0),
),
filled: true,
fillColor: FlutterFlowTheme.of(context)
.primaryBackground,
contentPadding: EdgeInsets.symmetric(
horizontal: 16.0, vertical: 12.0),
),
style: FlutterFlowTheme.of(context)
.bodyMedium
.override(
font: GoogleFonts.inter(),
letterSpacing: 0.0,
),
cursorColor:
FlutterFlowTheme.of(context).primaryText,
enableInteractiveSelection: true,
validator: _model.textControllerValidator
.asValidator(context),
),
),
),
FlutterFlowIconButton(
borderRadius: 24.0,
buttonSize: 48.0,
fillColor: FlutterFlowTheme.of(context).primary,
icon: Icon(
Icons.send_outlined,
color: FlutterFlowTheme.of(context).info,
size: 24.0,
),
onPressed: () async {
if (_model.textController!.text.trim().isEmpty) {
return;
}
await CommentsecctionRecord.collection
.doc()
.set(createCommentsecctionRecordData(
postid: widget.postid,
userid: currentUserReference,
comment: _model.textController!.text,
timestamp: getCurrentTimestamp,
));
safeSetState(() {
_model.textController?.clear();
});
},
),
],
),
),
),
),
],
),
),
),
);
}
}
