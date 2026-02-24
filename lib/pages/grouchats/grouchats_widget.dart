import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/emptychat/emptychat_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/timestamp_formatter.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/push_notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'grouchats_model.dart';
export 'grouchats_model.dart';

class GrouchatsWidget extends StatefulWidget {
  const GrouchatsWidget({
    super.key,
    String? username,
    this.profile,
    this.receivedgroupchats,
  }) : this.username = username ?? '';

  final String username;
  final String? profile;
  final DocumentReference? receivedgroupchats;

  static String routeName = 'grouchats';
  static String routePath = '/grouchats';

  @override
  State<GrouchatsWidget> createState() => _GrouchatsWidgetState();
}

class _GrouchatsWidgetState extends State<GrouchatsWidget> {
  late GrouchatsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GrouchatsModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _markCurrentGroupAsSeen() async {
    final groupRef = widget.receivedgroupchats;
    if (groupRef == null || currentUserReference == null) return;

    final updates = <String, dynamic>{
      'lastmessageseenby': FieldValue.arrayUnion([currentUserReference]),
    };
    if (currentUserUid.isNotEmpty) {
      updates['lastSeenAtByUid.$currentUserUid'] = FieldValue.serverTimestamp();
    }

    await groupRef.update(updates);
  }

  bool _isCurrentUserGroupAdmin(GroupsRecord groupRecord) {
    final userRef = currentUserReference;
    if (userRef == null) return false;
    if (groupRecord.adminId == userRef) return true;
    if (groupRecord.adminIds.contains(userRef)) return true;
    return false;
  }

  void _showSettingsMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isError
                ? Colors.white
                : FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        duration: Duration(milliseconds: 2200),
        backgroundColor: isError
            ? FlutterFlowTheme.of(context).error
            : FlutterFlowTheme.of(context).secondary,
      ),
    );
  }

  Future<void> _showRenameGroupDialog(GroupsRecord groupRecord) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: groupRecord.groupName);

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Rename group',
          style: FlutterFlowTheme.of(dialogContext).titleMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(dialogContext).titleMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(dialogContext).titleMedium.fontStyle,
                ),
                letterSpacing: 0.0,
              ),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: ffTranslate(context, 'Enter new group name'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (value) {
              final trimmed = (value ?? '').trim();
              if (trimmed.isEmpty) return 'Group name cannot be empty';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontWeight,
                      fontStyle: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontStyle,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          FFButtonWidget(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(dialogContext, nameController.text.trim());
              }
            },
            text: ffTranslate(context, 'Save'),
            options: FFButtonOptions(
              height: 40.0,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              color: FlutterFlowTheme.of(dialogContext).primary,
              textStyle: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontStyle: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontStyle,
                    ),
                    color: FlutterFlowTheme.of(dialogContext).info,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
      ),
    );
    nameController.dispose();

    if (newName == null) return;

    try {
      await groupRecord.reference.update({'GroupName': newName});
      _showSettingsMessage('Group renamed successfully');
    } catch (e) {
      debugPrint('Error renaming group: $e');
      _showSettingsMessage('Failed to rename group', isError: true);
    }
  }

  Future<void> _showManageMembersSheet(
    GroupsRecord groupRecord, {
    required bool isAddMode,
  }) async {
    final didUpdate = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => GestureDetector(
        onTap: () {
          FocusScope.of(sheetContext).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: MediaQuery.viewInsetsOf(sheetContext),
          child: _ManageMembersBottomSheet(
            groupRecord: groupRecord,
            isAddMode: isAddMode,
          ),
        ),
      ),
    );

    if (didUpdate == true) {
      _showSettingsMessage(
        isAddMode
            ? 'Members added successfully'
            : 'Members removed successfully',
      );
    }
  }

  Future<void> _showManageAdminsSheet(GroupsRecord groupRecord) async {
    final didUpdate = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => GestureDetector(
        onTap: () {
          FocusScope.of(sheetContext).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: MediaQuery.viewInsetsOf(sheetContext),
          child: _ManageAdminsBottomSheet(
            groupReference: groupRecord.reference,
          ),
        ),
      ),
    );

    if (didUpdate == true) {
      _showSettingsMessage('Group admins updated successfully');
    }
  }

  Future<void> _openGroupSettingsMenu(GroupsRecord groupRecord) async {
    if (!_isCurrentUserGroupAdmin(groupRecord)) {
      _showSettingsMessage(
        'Only group admins can access settings.',
        isError: true,
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.0)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: FlutterFlowTheme.of(sheetContext).primary,
              ),
              title: Text(
                'Rename group',
                style: FlutterFlowTheme.of(sheetContext).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontStyle,
                      ),
                      letterSpacing: 0.0,
                    ),
              ),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _showRenameGroupDialog(groupRecord);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person_add_alt_1_outlined,
                color: FlutterFlowTheme.of(sheetContext).primary,
              ),
              title: Text(
                'Add members',
                style: FlutterFlowTheme.of(sheetContext).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontStyle,
                      ),
                      letterSpacing: 0.0,
                    ),
              ),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _showManageMembersSheet(
                  groupRecord,
                  isAddMode: true,
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person_remove_outlined,
                color: FlutterFlowTheme.of(sheetContext).error,
              ),
              title: Text(
                'Remove members',
                style: FlutterFlowTheme.of(sheetContext).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(sheetContext).error,
                      letterSpacing: 0.0,
                    ),
              ),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _showManageMembersSheet(
                  groupRecord,
                  isAddMode: false,
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.admin_panel_settings_outlined,
                color: FlutterFlowTheme.of(sheetContext).primary,
              ),
              title: Text(
                'Manage admins',
                style: FlutterFlowTheme.of(sheetContext).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(sheetContext)
                            .bodyMedium
                            .fontStyle,
                      ),
                      letterSpacing: 0.0,
                    ),
              ),
              onTap: () async {
                Navigator.pop(sheetContext);
                await _showManageAdminsSheet(groupRecord);
              },
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupsRecord>(
      stream: GroupsRecord.getDocument(widget.receivedgroupchats!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderRadius: 20.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.chevron_left,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.safePop();
                },
              ),
              titleSpacing: 0.0,
              title: Text(
                widget.username.isNotEmpty ? widget.username : 'Group chat',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
              ),
              actions: [
                FlutterFlowIconButton(
                  borderRadius: 20.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 22.0,
                  ),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Group settings are unavailable right now.',
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        duration: Duration(milliseconds: 2000),
                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                      ),
                    );
                  },
                ),
              ],
              elevation: 2.0,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Unable to load this chat right now.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ),
          );
        }

        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: FFShimmerLoadingIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final grouchatsGroupsRecord = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: WillPopScope(
            onWillPop: () async {
              try {
                await _markCurrentGroupAsSeen();
              } catch (e) {
                debugPrint(
                    'Failed to mark group as seen on back navigation: $e');
              }
              return true;
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              appBar: AppBar(
                backgroundColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderRadius: 20.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.chevron_left,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    try {
                      await _markCurrentGroupAsSeen();
                    } catch (e) {
                      // Ensure back navigation still works even if update fails.
                      debugPrint('Failed to mark last message seen: $e');
                    } finally {
                      context.safePop();
                    }
                  },
                ),
                titleSpacing: 0.0,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(
                            grouchatsGroupsRecord.groupimage.isNotEmpty
                                ? grouchatsGroupsRecord.groupimage
                                : 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                          ).image,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              grouchatsGroupsRecord.groupName,
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${grouchatsGroupsRecord.userid.length} members',
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 22.0,
                    ),
                    onPressed: () async {
                      await _openGroupSettingsMenu(grouchatsGroupsRecord);
                    },
                  ),
                ],
                centerTitle: false,
                elevation: 2.0,
              ),
              body: SafeArea(
                top: true,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StreamBuilder<List<Chats2Record>>(
                        stream: queryChats2Record(
                          parent: widget.receivedgroupchats,
                          queryBuilder: (chats2Record) => chats2Record
                              .orderBy('timestamp', descending: true),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Text(
                                  'Unable to load messages. Please try again.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            );
                          }

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
                          List<Chats2Record> listViewChats2RecordList =
                              snapshot.data!;
                          if (listViewChats2RecordList.isEmpty) {
                            return const EmptychatWidget();
                          }

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            reverse: true,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listViewChats2RecordList.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewChats2Record =
                                  listViewChats2RecordList[listViewIndex];
                              return SizedBox(
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    if (listViewChats2Record.uidofsender ==
                                        currentUserReference)
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12.0, 0.0, 12.0, 18.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: 224.53,
                                                decoration: BoxDecoration(),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            listViewChats2Record
                                                                .nameofsender,
                                                            'You',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                fontSize: 11.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      6.0),
                                                          child: Container(
                                                            width: 3.0,
                                                            height: 3.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(
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
                                                              .formatChatTime(
                                                            listViewChats2Record
                                                                .timestamp,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                                fontSize: 11.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText
                                                                    .withValues(
                                                                        alpha:
                                                                            0.7),
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Builder(
                                                      builder: (context) {
                                                        final imagess =
                                                            listViewChats2Record
                                                                .images
                                                                .map((e) => e)
                                                                .toList();

                                                        return ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          reverse: true,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              imagess.length,
                                                          itemBuilder: (context,
                                                              imagessIndex) {
                                                            final imagessItem =
                                                                imagess[
                                                                    imagessIndex];
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          12.0),
                                                              child: Container(
                                                                width: 144.4,
                                                                height: 134.5,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: Image
                                                                        .network(
                                                                      listViewChats2Record
                                                                          .images
                                                                          .take(
                                                                              10)
                                                                          .toList()
                                                                          .firstOrNull!,
                                                                    ).image,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .accent2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(9.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    14.0,
                                                                    9.0,
                                                                    12.0,
                                                                    6.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              listViewChats2Record
                                                                  .message,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        12.0, 0.0, 0.0, 0.0),
                                                child: AuthUserStreamWidget(
                                                  builder: (context) =>
                                                      Container(
                                                    width: 25.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .alternate,
                                                      image: DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            currentUserPhoto,
                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                                          ),
                                                        ).image,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (listViewChats2Record.uidofsender !=
                                        currentUserReference)
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 18.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 12.0, 0.0),
                                              child: Container(
                                                width: 25.0,
                                                height: 25.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: Image.network(
                                                      valueOrDefault<String>(
                                                        widget.profile,
                                                        'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                                      ),
                                                    ).image,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 224.5,
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        valueOrDefault<String>(
                                                          listViewChats2Record
                                                              .nameofsender,
                                                          'User',
                                                        ),
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodySmall
                                                            .override(
                                                              font: GoogleFonts
                                                                  .inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              fontSize: 11.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                            ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    6.0),
                                                        child: Container(
                                                          width: 3.0,
                                                          height: 3.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText
                                                                .withValues(
                                                                    alpha: 0.5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        TimestampFormatter
                                                            .formatChatTime(
                                                          listViewChats2Record
                                                              .timestamp,
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodySmall
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText
                                                                      .withValues(
                                                                          alpha:
                                                                              0.7),
                                                                ),
                                                      ),
                                                    ],
                                                  ),
                                                  Builder(
                                                    builder: (context) {
                                                      final imagess =
                                                          listViewChats2Record
                                                              .images
                                                              .map((e) => e)
                                                              .toList();

                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        reverse: true,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            imagess.length,
                                                        itemBuilder: (context,
                                                            imagessIndex) {
                                                          final imagessItem =
                                                              imagess[
                                                                  imagessIndex];
                                                          return Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        12.0,
                                                                        0.0,
                                                                        12.0),
                                                            child: Container(
                                                              width: 144.4,
                                                              height: 134.5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: Image
                                                                      .network(
                                                                    listViewChats2Record
                                                                        .images
                                                                        .take(
                                                                            10)
                                                                        .toList()
                                                                        .firstOrNull!,
                                                                  ).image,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF4F5F6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              9.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  14.0,
                                                                  9.0,
                                                                  12.0,
                                                                  6.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            valueOrDefault<
                                                                String>(
                                                              listViewChats2Record
                                                                  .message,
                                                              'Er zijn heel veel events, welk genre zoek je?',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
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
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (_model.uploadedFileUrls_uploadDataHbj.length != 0)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 12.0, 12.0),
                              child: Builder(
                                builder: (context) {
                                  final images = _model
                                      .uploadedFileUrls_uploadDataHbj
                                      .toList();

                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(images.length,
                                        (imagesIndex) {
                                      final imagesItem = images[imagesIndex];
                                      return Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 12.0, 0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            imagesItem,
                                            width: 120.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.camera_enhance_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    final selectedMedia = await selectMedia(
                                      mediaSource: MediaSource.photoGallery,
                                      multiImage: true,
                                    );
                                    if (selectedMedia != null &&
                                        selectedMedia.every((m) =>
                                            validateFileFormat(
                                                m.storagePath, context))) {
                                      safeSetState(() =>
                                          _model.isDataUploading_uploadDataHbj =
                                              true);
                                      var selectedUploadedFiles =
                                          <FFUploadedFile>[];

                                      var downloadUrls = <String>[];
                                      try {
                                        showUploadMessage(
                                          context,
                                          'Uploading file...',
                                          showLoading: true,
                                        );
                                        selectedUploadedFiles = selectedMedia
                                            .map((m) => FFUploadedFile(
                                                  name: m.storagePath
                                                      .split('/')
                                                      .last,
                                                  bytes: m.bytes,
                                                  height: m.dimensions?.height,
                                                  width: m.dimensions?.width,
                                                  blurHash: m.blurHash,
                                                ))
                                            .toList();

                                        downloadUrls = (await Future.wait(
                                          selectedMedia.map(
                                            (m) async => await uploadData(
                                                m.storagePath, m.bytes),
                                          ),
                                        ))
                                            .where((u) => u != null)
                                            .map((u) => u!)
                                            .toList();
                                      } finally {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        _model.isDataUploading_uploadDataHbj =
                                            false;
                                      }
                                      if (selectedUploadedFiles.length ==
                                              selectedMedia.length &&
                                          downloadUrls.length ==
                                              selectedMedia.length) {
                                        safeSetState(() {
                                          _model.uploadedLocalFiles_uploadDataHbj =
                                              selectedUploadedFiles;
                                          _model.uploadedFileUrls_uploadDataHbj =
                                              downloadUrls;
                                        });
                                        showUploadMessage(context, 'Success!');
                                      } else {
                                        safeSetState(() {});
                                        showUploadMessage(
                                            context, 'Failed to upload data');
                                        return;
                                      }
                                    }
                                  },
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.keyboard_voice_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    final selectedFiles = await selectFiles(
                                      allowedExtensions: ['mp3'],
                                      multiFile: false,
                                    );
                                    if (selectedFiles != null) {
                                      safeSetState(() => _model
                                              .isDataUploading_uploadDataUue11 =
                                          true);
                                      var selectedUploadedFiles =
                                          <FFUploadedFile>[];

                                      var downloadUrls = <String>[];
                                      try {
                                        selectedUploadedFiles = selectedFiles
                                            .map((m) => FFUploadedFile(
                                                  name: m.storagePath
                                                      .split('/')
                                                      .last,
                                                  bytes: m.bytes,
                                                ))
                                            .toList();

                                        downloadUrls = (await Future.wait(
                                          selectedFiles.map(
                                            (f) async => await uploadData(
                                                f.storagePath, f.bytes),
                                          ),
                                        ))
                                            .where((u) => u != null)
                                            .map((u) => u!)
                                            .toList();
                                      } finally {
                                        _model.isDataUploading_uploadDataUue11 =
                                            false;
                                      }
                                      if (selectedUploadedFiles.length ==
                                              selectedFiles.length &&
                                          downloadUrls.length ==
                                              selectedFiles.length) {
                                        safeSetState(() {
                                          _model.uploadedLocalFile_uploadDataUue11 =
                                              selectedUploadedFiles.first;
                                          _model.uploadedFileUrl_uploadDataUue11 =
                                              downloadUrls.first;
                                        });
                                      } else {
                                        safeSetState(() {});
                                        return;
                                      }
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        1.0, 0.0, 12.0, 0.0),
                                    child: Container(
                                      width: 200.0,
                                      child: TextFormField(
                                        controller: _model.textController,
                                        focusNode: _model.textFieldFocusNode,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          '_model.textController',
                                          Duration(milliseconds: 0),
                                          () => safeSetState(() {}),
                                        ),
                                        autofocus: false,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          labelStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                          hintText: ffTranslate(
                                              context, 'Jou bericht'),
                                          hintStyle: FlutterFlowTheme.of(
                                                  context)
                                              .labelMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .fontStyle,
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          filled: true,
                                          fillColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        cursorColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                        validator: _model
                                            .textControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FlutterFlowIconButton(
                                      borderRadius: 100.0,
                                      buttonSize: 40.0,
                                      fillColor:
                                          FlutterFlowTheme.of(context).primary,
                                      disabledColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      disabledIconColor:
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                      icon: Icon(
                                        Icons.send_outlined,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        size: 24.0,
                                      ),
                                      onPressed: (_model.textController.text ==
                                                  null ||
                                              _model.textController.text == '')
                                          ? null
                                          : () async {
                                              await Chats2Record.createDoc(
                                                      widget
                                                          .receivedgroupchats!)
                                                  .set({
                                                ...createChats2RecordData(
                                                  message: _model
                                                      .textController.text,
                                                  timestamp:
                                                      getCurrentTimestamp,
                                                  uidofsender:
                                                      currentUserReference,
                                                  nameofsender:
                                                      currentUserDisplayName,
                                                  voice: _model
                                                      .uploadedFileUrl_uploadDataUue11,
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'images': _model
                                                        .uploadedFileUrls_uploadDataHbj,
                                                  },
                                                ),
                                              });

                                              await widget.receivedgroupchats!
                                                  .update({
                                                ...createGroupsRecordData(
                                                  lastmessage: _model
                                                      .textController.text,
                                                  timestamp:
                                                      getCurrentTimestamp,
                                                  lastvoice: _model
                                                      .uploadedFileUrl_uploadDataUue11,
                                                ),
                                                ...mapToFirestore(
                                                  {
                                                    'lastmessageseenby':
                                                        FieldValue.delete(),
                                                    'images': _model
                                                        .uploadedFileUrls_uploadDataHbj,
                                                  },
                                                ),
                                              });

                                              final seenUpdate =
                                                  <String, dynamic>{
                                                'lastmessageseenby':
                                                    FieldValue.arrayUnion(
                                                        [currentUserReference]),
                                              };
                                              if (currentUserUid.isNotEmpty) {
                                                seenUpdate[
                                                        'lastSeenAtByUid.$currentUserUid'] =
                                                    FieldValue
                                                        .serverTimestamp();
                                              }
                                              await widget.receivedgroupchats!
                                                  .update(seenUpdate);

                                              // Send push notification for group message
                                              await PushNotificationHelper
                                                  .sendGroupMessageNotification(
                                                groupRecord:
                                                    grouchatsGroupsRecord,
                                                senderName:
                                                    currentUserDisplayName,
                                                messageText:
                                                    _model.textController.text,
                                                senderRef:
                                                    currentUserReference!,
                                              );

                                              safeSetState(() {
                                                _model.textController?.clear();
                                              });
                                            },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
  }
}

class _ManageMembersBottomSheet extends StatefulWidget {
  const _ManageMembersBottomSheet({
    required this.groupRecord,
    required this.isAddMode,
  });

  final GroupsRecord groupRecord;
  final bool isAddMode;

  @override
  State<_ManageMembersBottomSheet> createState() =>
      _ManageMembersBottomSheetState();
}

class _ManageMembersBottomSheetState extends State<_ManageMembersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<DocumentReference> _selectedRefs = <DocumentReference>{};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _canRemoveMember(DocumentReference memberRef) {
    final isCreator = widget.groupRecord.adminId == memberRef;
    final isCurrentUser = memberRef == currentUserReference;
    return !isCreator && !isCurrentUser;
  }

  String _displayNameForUser(UsersRecord user) {
    if (user.displayName.isNotEmpty) return user.displayName;
    if (user.email.isNotEmpty) return user.email;
    return 'User';
  }

  List<UsersRecord> _filterUsers(List<UsersRecord> users) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      final name = user.displayName.toLowerCase();
      final email = user.email.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  Future<void> _applyChanges(List<UsersRecord> allUsers) async {
    if (_selectedRefs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isAddMode
                ? 'Select at least one member to add.'
                : 'Select at least one member to remove.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final selectedUsers = allUsers
          .where((user) => _selectedRefs.contains(user.reference))
          .toList();
      final selectedNames =
          selectedUsers.map(_displayNameForUser).toSet().toList();
      final refs = _selectedRefs.toList();

      final updatePayload = <String, dynamic>{
        'userid': widget.isAddMode
            ? FieldValue.arrayUnion(refs)
            : FieldValue.arrayRemove(refs),
        if (selectedNames.isNotEmpty)
          'usernames': widget.isAddMode
              ? FieldValue.arrayUnion(selectedNames)
              : FieldValue.arrayRemove(selectedNames),
        if (!widget.isAddMode) 'adminIds': FieldValue.arrayRemove(refs),
      };

      await widget.groupRecord.reference.update(updatePayload);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('Error updating members: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isAddMode
                ? 'Failed to add members'
                : 'Failed to remove members',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsersRecord>>(
      stream: queryUsersRecord(
        queryBuilder: (usersRecord) =>
            usersRecord.orderBy('display_name', descending: false),
      ),
      builder: (context, usersSnapshot) {
        if (!usersSnapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
            ),
            child: Center(
              child: FFShimmerLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final allUsers = usersSnapshot.data!;
        final eligibleUsers = widget.isAddMode
            ? allUsers
                .where((u) => !widget.groupRecord.userid.contains(u.reference))
                .toList()
            : allUsers
                .where((u) =>
                    widget.groupRecord.userid.contains(u.reference) &&
                    _canRemoveMember(u.reference))
                .toList();
        final usersToShow = _filterUsers(eligibleUsers);

        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.isAddMode ? 'Add Members' : 'Remove Members',
                        textAlign: TextAlign.center,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.check,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      onPressed:
                          _isSubmitting ? null : () => _applyChanges(allUsers),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: widget.isAddMode
                        ? 'Search users to add...'
                        : 'Search members to remove...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                SizedBox(height: 10.0),
                if (_selectedRefs.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_selectedRefs.length} selected',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                SizedBox(height: 8.0),
                Expanded(
                  child: eligibleUsers.isEmpty
                      ? Center(
                          child: Text(
                            widget.isAddMode
                                ? 'No available users to add.'
                                : 'No removable members.',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: usersToShow.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          itemBuilder: (context, index) {
                            final user = usersToShow[index];
                            final isSelected =
                                _selectedRefs.contains(user.reference);
                            final subtitle = user.email.isNotEmpty
                                ? user.email
                                : (widget.isAddMode
                                    ? 'Tap to add this member'
                                    : 'Tap to remove this member');

                            return ListTile(
                              onTap: _isSubmitting
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedRefs.remove(user.reference);
                                        } else {
                                          _selectedRefs.add(user.reference);
                                        }
                                      });
                                    },
                              leading: Container(
                                width: 42.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  image: user.photoUrl.isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(user.photoUrl)
                                              .image,
                                        )
                                      : null,
                                  shape: BoxShape.circle,
                                ),
                                child: user.photoUrl.isEmpty
                                    ? Icon(
                                        Icons.person_outline,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22.0,
                                      )
                                    : null,
                              ),
                              title: Text(
                                _displayNameForUser(user),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              subtitle: Text(
                                subtitle,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: _isSubmitting
                                    ? null
                                    : (value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedRefs.add(user.reference);
                                          } else {
                                            _selectedRefs
                                                .remove(user.reference);
                                          }
                                        });
                                      },
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                              ),
                            );
                          },
                        ),
                ),
                if (_isSubmitting)
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                      backgroundColor: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ManageAdminsBottomSheet extends StatefulWidget {
  const _ManageAdminsBottomSheet({
    required this.groupReference,
  });

  final DocumentReference groupReference;

  @override
  State<_ManageAdminsBottomSheet> createState() =>
      _ManageAdminsBottomSheetState();
}

class _ManageAdminsBottomSheetState extends State<_ManageAdminsBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  bool _isUpdating = false;
  bool _didUpdate = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isUserAdmin(GroupsRecord groupRecord, DocumentReference userRef) {
    if (groupRecord.adminId == userRef) return true;
    if (groupRecord.adminIds.contains(userRef)) return true;
    return false;
  }

  String _displayNameForUser(UsersRecord user) {
    if (user.displayName.isNotEmpty) return user.displayName;
    if (user.email.isNotEmpty) return user.email;
    return 'User';
  }

  List<UsersRecord> _filterUsers(List<UsersRecord> users) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      final name = user.displayName.toLowerCase();
      final email = user.email.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  Future<bool> _confirmDemote(UsersRecord user) async {
    final shouldDemote = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Remove admin role?',
          style: FlutterFlowTheme.of(dialogContext).titleMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(dialogContext).titleMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(dialogContext).titleMedium.fontStyle,
                ),
                letterSpacing: 0.0,
              ),
        ),
        content: Text(
          '${_displayNameForUser(user)} will lose admin privileges.',
          style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(dialogContext).bodyMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(dialogContext).bodyMedium.fontStyle,
                ),
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Cancel',
              style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontWeight,
                      fontStyle: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontStyle,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Remove',
              style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontWeight,
                      fontStyle: FlutterFlowTheme.of(dialogContext)
                          .bodyMedium
                          .fontStyle,
                    ),
                    color: FlutterFlowTheme.of(dialogContext).error,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );

    return shouldDemote == true;
  }

  Future<void> _setAdminStatus({
    required GroupsRecord groupRecord,
    required UsersRecord user,
    required bool makeAdmin,
  }) async {
    final memberRef = user.reference;
    final isCreator = groupRecord.adminId == memberRef;
    final isCurrentUser = memberRef == currentUserReference;

    if (!makeAdmin && isCreator) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The group creator cannot be removed as admin.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (isCurrentUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You cannot change your own admin role here.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() => _isUpdating = true);
    try {
      await groupRecord.reference.update({
        'adminIds': makeAdmin
            ? FieldValue.arrayUnion([memberRef])
            : FieldValue.arrayRemove([memberRef]),
      });

      _didUpdate = true;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            makeAdmin
                ? '${_displayNameForUser(user)} is now an admin.'
                : '${_displayNameForUser(user)} is no longer an admin.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );
    } catch (e) {
      debugPrint('Error updating admin status: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update admin role.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupsRecord>(
      stream: GroupsRecord.getDocument(widget.groupReference),
      builder: (context, groupSnapshot) {
        if (!groupSnapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
            ),
            child: Center(
              child: FFShimmerLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final groupRecord = groupSnapshot.data!;

        return StreamBuilder<List<UsersRecord>>(
          stream: queryUsersRecord(
            queryBuilder: (usersRecord) =>
                usersRecord.orderBy('display_name', descending: false),
          ),
          builder: (context, usersSnapshot) {
            if (!usersSnapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.72,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child: Center(
                  child: FFShimmerLoadingIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
              );
            }

            final allUsers = usersSnapshot.data!;
            final members = allUsers
                .where((user) => groupRecord.userid.contains(user.reference))
                .toList();
            final usersToShow = _filterUsers(members);

            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () => Navigator.pop(context, _didUpdate),
                        ),
                        Expanded(
                          child: Text(
                            'Manage Admins',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          icon: Icon(
                            Icons.check,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          ),
                          onPressed: () => Navigator.pop(context, _didUpdate),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: ffTranslate(context, 'Search members...'),
                        prefixIcon: Icon(
                          Icons.search,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Promote members to admin or remove admin access.',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: usersToShow.isEmpty
                          ? Center(
                              child: Text(
                                'No members found.',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: usersToShow.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1.0,
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                              itemBuilder: (context, index) {
                                final user = usersToShow[index];
                                final memberRef = user.reference;
                                final isCreator =
                                    groupRecord.adminId == memberRef;
                                final isCurrentUser =
                                    memberRef == currentUserReference;
                                final isAdmin =
                                    _isUserAdmin(groupRecord, memberRef);

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    width: 42.0,
                                    height: 42.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      image: user.photoUrl.isNotEmpty
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  Image.network(user.photoUrl)
                                                      .image,
                                            )
                                          : null,
                                      shape: BoxShape.circle,
                                    ),
                                    child: user.photoUrl.isEmpty
                                        ? Icon(
                                            Icons.person_outline,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 22.0,
                                          )
                                        : null,
                                  ),
                                  title: Text(
                                    _displayNameForUser(user),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  subtitle: Text(
                                    isCreator
                                        ? 'Creator'
                                        : isAdmin
                                            ? 'Admin'
                                            : 'Member',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  trailing: isCreator || isCurrentUser
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                            isCreator ? 'Creator' : 'You',
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        )
                                      : Switch.adaptive(
                                          value: isAdmin,
                                          onChanged: _isUpdating
                                              ? null
                                              : (value) async {
                                                  if (!value && isAdmin) {
                                                    final shouldDemote =
                                                        await _confirmDemote(
                                                            user);
                                                    if (!shouldDemote) {
                                                      return;
                                                    }
                                                  }

                                                  await _setAdminStatus(
                                                    groupRecord: groupRecord,
                                                    user: user,
                                                    makeAdmin: value,
                                                  );
                                                },
                                          activeColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                          activeTrackColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                          inactiveTrackColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                          inactiveThumbColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                        ),
                                );
                              },
                            ),
                    ),
                    if (_isUpdating)
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                          backgroundColor:
                              FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
