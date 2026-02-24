import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/timestamp_formatter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'group_list_model.dart';
export 'group_list_model.dart';

class GroupListWidget extends StatefulWidget {
  const GroupListWidget({super.key});

  static String routeName = 'group_list';
  static String routePath = '/groupList';

  @override
  State<GroupListWidget> createState() => _GroupListWidgetState();
}

class _GroupListWidgetState extends State<GroupListWidget> {
  late GroupListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupListModel());
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: StreamBuilder<List<GroupsRecord>>(
            stream: queryGroupsRecord(
              queryBuilder: (groupsRecord) => groupsRecord
                  .where(
                    'userid',
                    arrayContains: currentUserReference,
                  )
                  .orderBy('timestamp', descending: true),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
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
              List<GroupsRecord> listViewGroupsRecordList = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: listViewGroupsRecordList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewGroupsRecord =
                      listViewGroupsRecordList[listViewIndex];
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          'grouchats',
                          queryParameters: {
                            'receivedgroupchats': serializeParam(
                              listViewGroupsRecord.reference,
                              ParamType.DocumentReference,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(
                                      listViewGroupsRecord.groupimage.isNotEmpty
                                          ? listViewGroupsRecord.groupimage
                                          : 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                    ).image,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              listViewGroupsRecord.groupName,
                                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w600,
                                                      fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                    ),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (listViewGroupsRecord.adminId == currentUserReference)
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).primary,
                                                borderRadius: BorderRadius.circular(12.0),
                                              ),
                                              child: Text('Admin',
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight: FontWeight.w500,
                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context).info,
                                                      fontSize: 10.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w500,
                                                      fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                        child: Text(
                                          listViewGroupsRecord.lastmessage.isNotEmpty
                                              ? listViewGroupsRecord.lastmessage
                                              : 'No messages yet',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 12.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
                                              child: Text('${listViewGroupsRecord.userid.length} members',
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                      ),
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                      fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                    ),
                                              ),
                                            ),
                                            if (listViewGroupsRecord.timestamp != null)
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                child: Text('• ${TimestampFormatter.formatChatListPreview(listViewGroupsRecord.timestamp)}',
                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                          fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                        ),
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        letterSpacing: 0.0,
                                                        fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                        fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                      ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!listViewGroupsRecord.lastmessageseenby.contains(currentUserReference))
                                Container(
                                  width: 8.0,
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
