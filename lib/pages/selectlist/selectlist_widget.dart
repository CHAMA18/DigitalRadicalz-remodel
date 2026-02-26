import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selectlist_model.dart';
export 'selectlist_model.dart';

class SelectlistWidget extends StatefulWidget {
  const SelectlistWidget({super.key});

  static String routeName = 'selectlist';
  static String routePath = '/selectlist';

  @override
  State<SelectlistWidget> createState() => _SelectlistWidgetState();
}

class _SelectlistWidgetState extends State<SelectlistWidget> {
  late SelectlistModel _model;

  String _onselect = 'Groeps chat';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isConfirmedChatUser(UsersRecord user) {
    final hasUid = user.uid.trim().isNotEmpty;
    final hasDisplayName = user.displayName.trim().isNotEmpty;
    final isCurrentUser = user.reference == currentUserReference;
    return hasUid && hasDisplayName && !isCurrentUser;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectlistModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start A Chat', style: theme.headlineSmall),
              Text('Invite your friends or groups to chat with you!',
                  style: theme.labelMedium),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 8, 12, 4),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 44,
                fillColor: theme.alternate,
                icon: Icon(Icons.close_rounded, color: theme.secondaryText),
                onPressed: () => context.safePop(),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle buttons styled with app theme
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...['Berichten', 'Groeps chat'].map((label) {
                      final selected = _onselect == label;
                      return FFButtonWidget(
                        onPressed: () => setState(() => _onselect = label),
                        text: label,
                        options: FFButtonOptions(
                          height: 36,
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          color: selected
                              ? theme.primary
                              : theme.secondaryBackground,
                          textStyle: theme.titleSmall.override(
                            color: selected
                                ? theme.secondaryBackground
                                : theme.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                          elevation: selected ? 1.5 : 0,
                          borderRadius: BorderRadius.circular(20),
                          borderSide: selected
                              ? BorderSide.none
                              : BorderSide(color: theme.alternate),
                          hoverColor: selected
                              ? theme.primary.withValues(alpha: 0.92)
                              : theme.secondaryBackground,
                          focusBorderSide: BorderSide(color: theme.primary),
                          focusBorderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 16),
                if (_onselect == 'Groeps chat') ...[
                  Text('Join Group', style: theme.labelMedium),
                  SizedBox(height: 12),
                  // Create Group Chat row
                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        CreateGroupPage.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.alternate),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x1A000000),
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: theme.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.group_add_rounded,
                                  color: theme.primary,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Create Group Chat',
                                style: theme.titleSmall.override(
                                  fontFamily: 'Inter',
                                  color: theme.primaryText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: theme.secondaryText,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  // User's groups list
                  StreamBuilder<List<GroupsRecord>>(
                    stream: queryGroupsRecord(
                      queryBuilder: (groups) => groups
                          .where('userid', arrayContains: currentUserReference)
                          .orderBy('timestamp', descending: true),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: FFShimmerLoadingIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(theme.primary),
                            ),
                          ),
                        );
                      }
                      final groups = snapshot.data!
                          .where((g) =>
                              (g.groupName.trim().isNotEmpty) &&
                              (g.groupName.trim().toLowerCase() !=
                                  'untitled group'))
                          .toList();
                      if (groups.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('No groups yet. Create one to get started!',
                              style: theme.bodyMedium),
                        );
                      }
                      return ListView.separated(
                        itemCount: groups.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          final isAdmin = group.adminId == currentUserReference;
                          return Dismissible(
                            key: Key(group.reference.id),
                            direction: isAdmin
                                ? DismissDirection.endToStart
                                : DismissDirection.none,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.delete, color: theme.info),
                            ),
                            confirmDismiss: (direction) async {
                              if (!isAdmin) return false;
                              return await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor:
                                          theme.secondaryBackground,
                                      title: Text('Delete Group',
                                          style: theme.titleLarge),
                                      content: Text('Are you sure you want to delete "${group.groupName}"? This will remove the group for all members and cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('Cancel',
                                              style: theme.bodyMedium.override(
                                                  color: theme.secondaryText)),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text('Delete',
                                              style: theme.bodyMedium.override(
                                                  color: theme.error)),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                            },
                            onDismissed: (_) async {
                              try {
                                await group.reference.delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Group "${group.groupName}" deleted'),
                                    backgroundColor: theme.primary,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete group. Please try again.'),
                                    backgroundColor: theme.error,
                                  ),
                                );
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                context.pushNamed(
                                  GrouchatsWidget.routeName,
                                  queryParameters: {
                                    'receivedgroupchats': serializeParam(
                                        group.reference,
                                        ParamType.DocumentReference),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.secondaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.alternate),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          group.groupimage.isNotEmpty
                                              ? NetworkImage(group.groupimage)
                                              : null,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  group.groupName.isNotEmpty
                                                      ? group.groupName
                                                      : 'Untitled Group',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: theme.bodyMedium
                                                      .override(
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              if (isAdmin)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: theme.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text('Admin',
                                                      style: theme.bodySmall
                                                          .override(
                                                              color: theme.info,
                                                              fontSize: 10)),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            group.lastmessage.isNotEmpty
                                                ? group.lastmessage
                                                : 'No messages yet',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.bodyMedium.override(
                                                color: theme.secondaryText,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],

                // Berichten: full user list to start a direct chat
                if (_onselect == 'Berichten') ...[
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
                    child: Text('Start a chat', style: theme.labelMedium),
                  ),
                  StreamBuilder<List<UsersRecord>>(
                    stream: queryUsersRecord(
                      queryBuilder: (users) => users.orderBy('display_name'),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: FFShimmerLoadingIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(theme.primary),
                            ),
                          ),
                        );
                      }
                      final users =
                          snapshot.data!.where(_isConfirmedChatUser).toList();
                      if (users.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No confirmed users found.',
                              style: theme.bodyMedium),
                        );
                      }
                      return ListView.separated(
                        itemCount: users.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return InkWell(
                            onTap: () async {
                              if (currentUserReference == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Please sign in to start a chat.')),
                                );
                                return;
                              }
                              try {
                                // Find or create a 1-on-1 chat
                                final existing =
                                    await functions.findExistingChat(
                                  currentUserReference!,
                                  user.reference,
                                );
                                DocumentReference chatRef;
                                if (existing != null) {
                                  chatRef = existing.reference;
                                } else {
                                  final newDoc = ChatsRecord.collection.doc();
                                  await newDoc.set({
                                    ...createChatsRecordData(
                                      lastmessage: '',
                                      timestamp: getCurrentTimestamp,
                                    ),
                                    ...mapToFirestore({
                                      'userid': functions.generateListOfUsers(
                                          currentUserReference!,
                                          user.reference),
                                      'usernames':
                                          functions.generateListOfNames(
                                              currentUserDisplayName,
                                              user.displayName),
                                      'lastmessageseenby':
                                          <DocumentReference>[],
                                      'images': <String>[],
                                    }),
                                  });
                                  chatRef = newDoc;
                                }
                                // Navigate to full chat screen
                                FFAppState().chatTab = 'Berichten';
                                context.pushReplacementNamed(
                                  Chat2Widget.routeName,
                                  queryParameters: {
                                    'receiveChat': serializeParam(
                                        chatRef, ParamType.DocumentReference),
                                    'username': serializeParam(
                                        user.displayName, ParamType.String),
                                    'profile': serializeParam(
                                        user.photoUrl, ParamType.String),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Failed to open chat. Please try again.')),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.secondaryBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.alternate),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  user.photoUrl.isNotEmpty
                                      ? CircleAvatar(
                                          radius: 22,
                                          backgroundImage:
                                              NetworkImage(user.photoUrl),
                                        )
                                      : CircleAvatar(
                                          radius: 22,
                                          backgroundColor: theme.alternate,
                                          child: Icon(
                                            Icons.person,
                                            color: theme.secondaryText,
                                            size: 24,
                                          ),
                                        ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.displayName,
                                            style: theme.bodyMedium.override(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600)),
                                        Text(user.email,
                                            style: theme.bodyMedium.override(
                                                color: theme.secondaryText,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,
                                      color: theme.secondaryText),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
