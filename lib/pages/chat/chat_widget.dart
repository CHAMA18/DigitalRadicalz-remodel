import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/emptyuser/emptyuser_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/timestamp_formatter.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

/// Badge widget for showing unread count on tab buttons
class _TabBadge extends StatelessWidget {
  const _TabBadge({
    required this.count,
    required this.isSelected,
  });

  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(left: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      constraints: BoxConstraints(minWidth: 18.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: TextStyle(
          color:
              isSelected ? FlutterFlowTheme.of(context).primary : Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Badge widget for unread count on each group row.
class _GroupUnreadBadge extends StatelessWidget {
  const _GroupUnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return SizedBox.shrink();

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
      padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
      constraints: BoxConstraints(minWidth: 20.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  static String routeName = 'Chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

// Clean up duplicate chats when the chat page loads
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (currentUserReference != null) {
        await functions.removeDuplicateChats(currentUserReference!);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  bool _isCurrentUserGroupAdmin(GroupsRecord groupRecord) {
    final userRef = currentUserReference;
    if (userRef == null) return false;
    if (groupRecord.adminId == userRef) return true;
    if (groupRecord.adminIds.contains(userRef)) return true;
    return false;
  }

  DateTime? _lastSeenAtForGroup(GroupsRecord groupRecord) {
    final uid = currentUserUid;
    if (uid.isEmpty) return null;

    final dynamic rawMap = groupRecord.snapshotData['lastSeenAtByUid'];
    if (rawMap is! Map) return null;

    final dynamic rawValue = rawMap[uid];
    if (rawValue is DateTime) return rawValue;
    if (rawValue is String) return DateTime.tryParse(rawValue);
    return null;
  }

  Future<int> _getUnreadMessageCountForGroup(GroupsRecord groupRecord) async {
    final userRef = currentUserReference;
    if (userRef == null) return 0;

    final hasUnreadLastMessage =
        !groupRecord.lastmessageseenby.contains(userRef);
    if (!hasUnreadLastMessage) return 0;

    final lastSeenAt = _lastSeenAtForGroup(groupRecord);
    if (lastSeenAt == null) {
      // Backward-compat fallback for groups without per-user seen timestamps.
      return 1;
    }

    try {
      final unreadMessages = await queryChats2RecordOnce(
        parent: groupRecord.reference,
        queryBuilder: (query) => query
            .where('timestamp', isGreaterThan: lastSeenAt)
            .orderBy('timestamp', descending: true)
            .limit(300),
      );

      final unreadCount = unreadMessages
          .where((msg) => msg.uidofsender != null && msg.uidofsender != userRef)
          .length;

      return unreadCount;
    } catch (e) {
      debugPrint(
          'Failed to compute unread count for group ${groupRecord.reference.id}: $e');
      return 1;
    }
  }

  Future<int> _getTotalUnreadMessagesForGroups(
    List<GroupsRecord> groups,
  ) async {
    if (groups.isEmpty) return 0;

    final counts = await Future.wait(
      groups.map(_getUnreadMessageCountForGroup),
    );
    return counts.fold<int>(0, (sum, count) => sum + count);
  }

  Future<bool> _confirmDeleteGroup(
      BuildContext context, GroupsRecord group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              FlutterFlowTheme.of(dialogContext).secondaryBackground,
          title: Text(
            'Delete Group',
            style: FlutterFlowTheme.of(dialogContext).headlineSmall.override(
                  letterSpacing: 0.0,
                ),
          ),
          content: Text(
            'Delete "${group.groupName}" for all members? This cannot be undone.',
            style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancel',
                style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                      color: FlutterFlowTheme.of(dialogContext).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Delete',
                style: FlutterFlowTheme.of(dialogContext).bodyMedium.override(
                      color: FlutterFlowTheme.of(dialogContext).error,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }

  Future<bool> _deleteGroupRecord(
    BuildContext context,
    GroupsRecord groupRecord,
  ) async {
    try {
      await groupRecord.reference.delete();
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Group deleted successfully.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          duration: Duration(seconds: 2),
        ),
      );
      return true;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete group. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                context.goNamed(HomePageWidget.routeName);
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.goNamed(HomePageWidget.routeName);
                    },
                    child: Icon(
                      Icons.chevron_left,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 32.0,
                    ),
                  ),
                  Text(
                    'Back',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              'Chat',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Back',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w500,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                        color: Color(0x0014181B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                ),
                FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.add,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(
                      SelectlistWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.bottomToTop,
                        ),
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: _model.textController,
                      focusNode: _model.textFieldFocusNode,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                        hintText: ffTranslate(context, 'Search....'),
                        hintStyle:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        fillColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24.0,
                        ),
                        suffixIcon:
                            (_model.textController?.text.isNotEmpty ?? false)
                                ? InkWell(
                                    onTap: () {
                                      _model.textController?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(Icons.clear,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText),
                                  )
                                : null,
                      ),
                      onChanged: (_) => safeSetState(() {}),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
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
                      cursorColor: FlutterFlowTheme.of(context).primaryText,
                      validator:
                          _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 0.0, 12.0),
                  child: StreamBuilder<List<ChatsRecord>>(
                    stream: queryChatsRecord(
                      queryBuilder: (chatsRecord) => chatsRecord.where(
                        'userid',
                        arrayContains: currentUserReference,
                      ),
                    ),
                    builder: (context, directChatSnapshot) {
// Count unread direct messages
                      int unreadDirectCount = 0;
                      if (directChatSnapshot.hasData) {
                        for (final chat in directChatSnapshot.data!) {
                          if (!chat.lastmessageseenby
                              .contains(currentUserReference)) {
                            unreadDirectCount++;
                          }
                        }
                      }

                      return StreamBuilder<List<GroupsRecord>>(
                        stream: queryGroupsRecord(
                          queryBuilder: (groupsRecord) => groupsRecord.where(
                            'userid',
                            arrayContains: currentUserReference,
                          ),
                        ),
                        builder: (context, groupChatSnapshot) {
                          final allGroups = groupChatSnapshot.data ?? const [];

                          // Keep tab badge logic consistent with visible list
                          // (skip placeholder/test groups by name and last message).
                          final visibleGroups = allGroups.where((g) {
                            final name = g.groupName
                                .trim()
                                .toLowerCase()
                                .replaceAll('!', '');
                            final last = g.lastmessage
                                .trim()
                                .toLowerCase()
                                .replaceAll('!', '');
                            return name != 'say hello' && last != 'say hello';
                          }).toList();

                          return FutureBuilder<int>(
                            future:
                                _getTotalUnreadMessagesForGroups(visibleGroups),
                            builder: (context, unreadSnapshot) {
                              final fallbackCount = visibleGroups
                                  .where((g) => !g.lastmessageseenby
                                      .contains(currentUserReference))
                                  .length;
                              final unreadGroupCount =
                                  unreadSnapshot.data ?? fallbackCount;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
// Berichten (Direct Messages) Tab
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 12.0, 0.0),
                                      child: InkWell(
                                        onTap: () async {
                                          FFAppState().chatTab = 'Berichten';
                                          safeSetState(() {});
                                        },
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        child: Container(
                                          height: 24.0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: FFAppState()
                                                        .chatTab ==
                                                    'Berichten'
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Berichten',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      font: GoogleFonts
                                                          .interTight(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      color: FFAppState()
                                                                  .chatTab ==
                                                              'Berichten'
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .info
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                              _TabBadge(
                                                count: unreadDirectCount,
                                                isSelected:
                                                    FFAppState().chatTab ==
                                                        'Berichten',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
// Community chat Tab
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 12.0, 0.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          FFAppState().chatTab =
                                              'Community chat';
                                          safeSetState(() {});
                                        },
                                        text: ffTranslate(
                                            context, 'Community chat'),
                                        options: FFButtonOptions(
                                          height: 24.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FFAppState().chatTab ==
                                                  'Community chat'
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .alternate,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.interTight(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: FFAppState().chatTab ==
                                                        'Community chat'
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .info
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          hoverColor: FFAppState().chatTab ==
                                                  'Community chat'
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withValues(alpha: 0.1),
                                          splashColor:
                                              FlutterFlowTheme.of(context)
                                                  .primary
                                                  .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                        ),
                                      ),
                                    ),
// Groeps chat Tab
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 12.0, 0.0),
                                      child: InkWell(
                                        onTap: () async {
                                          FFAppState().chatTab = 'Groeps chat';
                                          safeSetState(() {});
                                        },
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                        child: Container(
                                          height: 24.0,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: FFAppState().chatTab ==
                                                    'Groeps chat'
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .alternate,
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Groeps chat',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleSmall
                                                    .override(
                                                      font: GoogleFonts
                                                          .interTight(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      color: FFAppState()
                                                                  .chatTab ==
                                                              'Groeps chat'
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .info
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                              _TabBadge(
                                                count: unreadGroupCount,
                                                isSelected:
                                                    FFAppState().chatTab ==
                                                        'Groeps chat',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        FFAppState().chatTab,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 22.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ],
                  ),
                ),
                if (FFAppState().chatTab == 'Berichten')
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: StreamBuilder<List<ChatsRecord>>(
                      stream: queryChatsRecord(
                        queryBuilder: (chatsRecord) => chatsRecord
                            .where(
                              'userid',
                              arrayContains: currentUserReference,
                            )
                            .orderBy('timestamp', descending: true),
                      ),
                      builder: (context, snapshot) {
// Handle loading state
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
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

// Handle error state (including permission denied)
                        if (snapshot.hasError) {
                          debugPrint('Chats query error: ${snapshot.error}');
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 48.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    'Unable to load messages',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Please try again later',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

// Handle no data state
                        if (!snapshot.hasData) {
                          return EmptyuserWidget();
                        }

                        List<ChatsRecord> allChats = snapshot.data!;

// Filter out duplicates in UI as additional safeguard
                        Map<DocumentReference, ChatsRecord> uniqueChats = {};
                        for (final chat in allChats) {
                          if (chat.userid.length == 2) {
                            final otherUser = chat.userid.firstWhere(
                                (ref) => ref != currentUserReference);

// Keep the most recent chat for each other user
                            if (!uniqueChats.containsKey(otherUser) ||
                                (chat.timestamp != null &&
                                    (uniqueChats[otherUser]!.timestamp ==
                                            null ||
                                        chat.timestamp!.isAfter(
                                            uniqueChats[otherUser]!
                                                .timestamp!)))) {
                              uniqueChats[otherUser] = chat;
                            }
                          } else {
// For group chats, use chat reference as key
                            uniqueChats[chat.reference] = chat;
                          }
                        }

                        List<ChatsRecord> columnChatsRecordList =
                            uniqueChats.values.toList();

// Sort by timestamp descending
                        columnChatsRecordList.sort((a, b) {
                          if (a.timestamp == null && b.timestamp == null)
                            return 0;
                          if (a.timestamp == null) return 1;
                          if (b.timestamp == null) return -1;
                          return b.timestamp!.compareTo(a.timestamp!);
                        });

// Apply search filter (by usernames or last message)
                        final search = (_model.textController?.text ?? '')
                            .trim()
                            .toLowerCase();
                        final filteredChats = search.isEmpty
                            ? columnChatsRecordList
                            : columnChatsRecordList.where((chat) {
                                final nameMatch = chat.usernames
                                    .map((e) => e.toLowerCase())
                                    .any((n) => n.contains(search));
                                final messageMatch = (chat.lastmessage)
                                    .toLowerCase()
                                    .contains(search);
                                return nameMatch || messageMatch;
                              }).toList();

                        if (filteredChats.isEmpty) {
                          return EmptyuserWidget();
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(filteredChats.length,
                              (columnIndex) {
                            final columnChatsRecord =
                                filteredChats[columnIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              child: StreamBuilder<UsersRecord>(
                                stream: UsersRecord.getDocument(
                                    functions.getOtherUserRef(
                                        columnChatsRecord.userid.toList(),
                                        currentUserReference!)),
                                builder: (context, snapshot) {
// Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: FFShimmerLoadingIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final columnUsersRecord = snapshot.data!;

                                  return Dismissible(
                                    key: Key(columnChatsRecord.reference.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      color: FlutterFlowTheme.of(context).error,
                                      child: Icon(
                                        Icons.delete,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        size: 24.0,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            title: Text(
                                              'Delete Chat',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .override(
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            content: Text(
                                              'Are you sure you want to delete this chat with ${columnUsersRecord.displayName}? This action cannot be undone.',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: Text(
                                                  'Cancel',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: Text(
                                                  'Delete',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    onDismissed: (direction) async {
                                      try {
                                        await columnChatsRecord.reference
                                            .delete();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Chat with ${columnUsersRecord.displayName} deleted',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to delete chat. Please try again.',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .error,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          Chat2Widget.routeName,
                                          queryParameters: {
                                            'receiveChat': serializeParam(
                                              columnChatsRecord.reference,
                                              ParamType.DocumentReference,
                                            ),
                                            'username': serializeParam(
                                              columnUsersRecord.displayName,
                                              ParamType.String,
                                            ),
                                            'profile': serializeParam(
                                              columnUsersRecord.photoUrl,
                                              ParamType.String,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            kTransitionInfoKey: TransitionInfo(
                                              hasTransition: true,
                                              transitionType:
                                                  PageTransitionType.fade,
                                              duration:
                                                  Duration(milliseconds: 0),
                                            ),
                                          },
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 51.0,
                                                    height: 54.0,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            columnUsersRecord
                                                                .photoUrl,
                                                            'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                                          ),
                                                        ).image,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(24.0, 0.0,
                                                                0.0, 0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          valueOrDefault<
                                                              String>(
                                                            columnUsersRecord
                                                                .displayName,
                                                            'Unknown User',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              columnChatsRecord
                                                                  .lastmessage,
                                                              'hi this is the last message i sent to you please read it ',
                                                            ).maybeHandleOverflow(
                                                              maxChars: 24,
                                                              replacement: '…',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (columnChatsRecord
                                                              .lastmessageseenby
                                                              .contains(
                                                                  currentUserReference) ==
                                                          false)
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      8.0,
                                                                      0.0),
                                                          child: Container(
                                                            width: 8.0,
                                                            height: 8.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ),
                                                      Text(
                                                        TimestampFormatter
                                                            .formatChatListPreview(
                                                          columnChatsRecord
                                                              .timestamp,
                                                        ),
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
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              fontSize: 11.0,
                                                              letterSpacing:
                                                                  0.0,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            height: 24.0,
                                            thickness: 2.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                if (FFAppState().chatTab == 'Groeps chat')
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                    child: StreamBuilder<List<GroupsRecord>>(
                      stream: queryGroupsRecord(
                        queryBuilder: (groupsRecord) => groupsRecord
                            .where('userid',
                                arrayContains: currentUserReference)
                            .orderBy('timestamp', descending: true),
                      ),
                      builder: (context, snapshot) {
// Handle loading state
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
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

// Handle error state (including permission denied)
                        if (snapshot.hasError) {
                          debugPrint('Groups query error: ${snapshot.error}');
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.group_off,
                                    size: 48.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    'Unable to load group chats',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Please try again later',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

// Handle no data state
                        if (!snapshot.hasData) {
                          return EmptyuserWidget();
                        }

                        List<GroupsRecord> allGroups = snapshot.data!;
                        final search = (_model.textController?.text ?? '')
                            .trim()
                            .toLowerCase();
                        final filteredGroups = search.isEmpty
                            ? allGroups
                            : allGroups
                                .where((g) =>
                                    g.groupName.toLowerCase().contains(search))
                                .toList();

// Remove placeholder/test groups named "Say hello!"
                        final visibleGroups = filteredGroups.where((g) {
                          final name = g.groupName
                              .trim()
                              .toLowerCase()
                              .replaceAll('!', '');
                          final last = g.lastmessage
                              .trim()
                              .toLowerCase()
                              .replaceAll('!', '');
                          return name != 'say hello' && last != 'say hello';
                        }).toList();

                        if (visibleGroups.isEmpty) {
                          return EmptyuserWidget();
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: visibleGroups.length,
                          itemBuilder: (context, index) {
                            final g = visibleGroups[index];
                            final bool hasUnread = !g.lastmessageseenby
                                .contains(currentUserReference);
                            final bool isGroupAdmin =
                                _isCurrentUserGroupAdmin(g);
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 12.0, 12.0, 0.0),
                              child: Dismissible(
                                key: Key('group_${g.reference.id}'),
                                direction: isGroupAdmin
                                    ? DismissDirection.endToStart
                                    : DismissDirection.none,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).error,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  if (!isGroupAdmin) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Only admins can delete this group.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).error,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    return false;
                                  }

                                  final confirmed =
                                      await _confirmDeleteGroup(context, g);
                                  if (!confirmed) return false;
                                  return await _deleteGroupRecord(context, g);
                                },
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                      GrouchatsWidget.routeName,
                                      queryParameters: {
                                        'receivedgroupchats': serializeParam(
                                          g.reference,
                                          ParamType.DocumentReference,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: FutureBuilder<int>(
                                      future: hasUnread
                                          ? _getUnreadMessageCountForGroup(g)
                                          : Future.value(0),
                                      builder: (context, unreadSnapshot) {
                                        final unreadMessageCount =
                                            unreadSnapshot.data ??
                                                (hasUnread ? 1 : 0);
                                        final hasUnreadMessages =
                                            unreadMessageCount > 0;

                                        return Padding(
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
                                                      g.groupimage.isNotEmpty
                                                          ? g.groupimage
                                                          : 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                                    ).image,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              g.groupName,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyLarge
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .inter(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyLarge
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          if (isGroupAdmin)
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primary,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                              child: Text(
                                                                'Admin',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .info,
                                                                      fontSize:
                                                                          10.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          g.lastmessage
                                                                  .isNotEmpty
                                                              ? g.lastmessage
                                                              : 'No messages yet',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight: hasUnreadMessages
                                                                      ? FontWeight
                                                                          .w600
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: hasUnreadMessages
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons.people,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 12.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                '${g.userid.length} members',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            if (g.timestamp !=
                                                                null)
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  '• ${TimestampFormatter.formatChatListPreview(g.timestamp)}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodySmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodySmall
                                                                              .fontStyle,
                                                                        ),
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodySmall
                                                                            .fontStyle,
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
                                              _GroupUnreadBadge(
                                                count: unreadMessageCount,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
                if (FFAppState().chatTab == 'Community chat')
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                    child: StreamBuilder<List<CommunitiesRecord>>(
                      stream: queryCommunitiesRecord(
                        queryBuilder: (communitiesRecord) =>
                            communitiesRecord.where(
                          'joinedby',
                          arrayContains: currentUserReference,
                        ),
                      ),
                      builder: (context, snapshot) {
// Handle loading state
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
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

// Handle error state (including permission denied)
                        if (snapshot.hasError) {
                          debugPrint(
                              'Communities query error: ${snapshot.error}');
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 48.0,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  SizedBox(height: 12.0),
                                  Text(
                                    'Unable to load communities',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Please try again later',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.inter(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

// Handle no data state
                        if (!snapshot.hasData) {
                          return EmptyuserWidget();
                        }

                        List<CommunitiesRecord> columnCommunitiesRecordList =
                            snapshot.data!;

// Apply search filter by community name, category, or description
                        final search = (_model.textController?.text ?? '')
                            .trim()
                            .toLowerCase();
                        final filteredCommunities = search.isEmpty
                            ? columnCommunitiesRecordList
                            : columnCommunitiesRecordList.where((c) {
                                final name = (c.name).toLowerCase();
                                final cat = (c.category).toLowerCase();
                                final desc = (c.description).toLowerCase();
                                return name.contains(search) ||
                                    cat.contains(search) ||
                                    desc.contains(search);
                              }).toList();

                        if (filteredCommunities.isEmpty) {
                          return EmptyuserWidget();
                        }

                        return Container(
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: List.generate(filteredCommunities.length,
                                (columnIndex) {
                              final columnCommunitiesRecord =
                                  filteredCommunities[columnIndex];
                              return Positioned(
                                left: 0,
                                top: (columnIndex * 180),
                                child: Draggable(
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      height: 165.8,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate
                                            .withValues(alpha: 0.8),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  maxSimultaneousDrags: 0,
                                  childWhenDragging: Container(),
                                  onDragEnd: (DraggableDetails details) {
                                    setState(() {
                                      _model.containerPositionX =
                                          details.offset.dx;
                                      _model.containerPositionY =
                                          details.offset.dy;
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                          CommunitypostsWidget.routeName,
                                          queryParameters: {
                                            'communiyref': serializeParam(
                                              columnCommunitiesRecord.reference,
                                              ParamType.DocumentReference,
                                            ),
                                          }.withoutNulls,
                                        );
                                      },
                                      child: Container(
                                        height: 165.8,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color: Color(0x33000000),
                                              offset: Offset(
                                                0.0,
                                                2.0,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 12.0, 12.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.contain,
                                                            image: Image.asset(
                                                              'assets/images/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                                            ).image,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  valueOrDefault<
                                                                      String>(
                                                                    columnCommunitiesRecord
                                                                        .name,
                                                                    'Community Name',
                                                                  ),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          2.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      dateTimeFormat(
                                                                          "yMMMd",
                                                                          columnCommunitiesRecord
                                                                              .createdat),
                                                                      'Sep 4, 2025',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
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
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 4.0, 12.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  8.0),
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          columnCommunitiesRecord
                                                              .description,
                                                          'No matter what challenges come our way, we are in this together. Each step forward becomes lighter when we walk side by side, supporting and encouraging one another.',
                                                        ).maybeHandleOverflow(
                                                          maxChars: 150,
                                                          replacement: '…',
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 6,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 8.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  FFButtonWidget(
                                                    onPressed: () {
                                                      print(
                                                          'Button pressed ...');
                                                    },
                                                    text:
                                                        columnCommunitiesRecord
                                                            .category,
                                                    options: FFButtonOptions(
                                                      height: 19.3,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  16.0,
                                                                  0.0,
                                                                  16.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color: Color(0xFFDBEAFE),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: Color(
                                                                    0xFF1E40B6),
                                                                fontSize: 12.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                      elevation: 0.0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(6.0, 0.0,
                                                                0.0, 0.0),
                                                    child: StreamBuilder<
                                                        List<
                                                            CommunityMembershipsRecord>>(
                                                      stream:
                                                          queryCommunityMembershipsRecord(
                                                        queryBuilder:
                                                            (communityMembershipsRecord) =>
                                                                communityMembershipsRecord
                                                                    .where(
                                                          'communityId',
                                                          isEqualTo:
                                                              columnCommunitiesRecord
                                                                  .reference,
                                                        ),
                                                        singleRecord: true,
                                                      ),
                                                      builder:
                                                          (context, snapshot) {
// Customize what your widget looks like when it's loading.
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: SizedBox(
                                                              width: 50.0,
                                                              height: 50.0,
                                                              child:
                                                                  FFShimmerLoadingIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        List<CommunityMembershipsRecord>
                                                            richTextCommunityMembershipsRecordList =
                                                            snapshot.data!;
// Return an empty Container when the item does not exist.
                                                        if (snapshot
                                                            .data!.isEmpty) {
                                                          return Container();
                                                        }
                                                        final richTextCommunityMembershipsRecord =
                                                            richTextCommunityMembershipsRecordList
                                                                    .isNotEmpty
                                                                ? richTextCommunityMembershipsRecordList
                                                                    .first
                                                                : null;

                                                        return RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  formatNumber(
                                                                    richTextCommunityMembershipsRecord
                                                                        ?.joineduser
                                                                        ?.length,
                                                                    formatType:
                                                                        FormatType
                                                                            .decimal,
                                                                    decimalType:
                                                                        DecimalType
                                                                            .periodDecimal,
                                                                  ),
                                                                  '0',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text: ffTranslate(
                                                                    context,
                                                                    ' Members'),
                                                                style:
                                                                    TextStyle(),
                                                              )
                                                            ],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        );
                                                      },
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
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
