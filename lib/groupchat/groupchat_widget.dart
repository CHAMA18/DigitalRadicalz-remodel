import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/emptychat/emptychat_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/timestamp_formatter.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'groupchat_model.dart';
export 'groupchat_model.dart';

/// Create a chat screen where it shows my message and other users message. My
/// message on the right hand side and the other users message on the left
/// handside
class GroupchatWidget extends StatefulWidget {
  const GroupchatWidget({
    super.key,
    required this.chatref,
  });

  final DocumentReference? chatref;

  static String routeName = 'Groupchat';
  static String routePath = '/groupchat';

  @override
  State<GroupchatWidget> createState() => _GroupchatWidgetState();
}

class _GroupchatWidgetState extends State<GroupchatWidget> {
  late GroupchatModel _model;
  bool _canSend = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupchatModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    
    // Listen for text changes to update send button state
    _model.textController!.addListener(_onTextChanged);
  }
  
  void _onTextChanged() {
    final canSend = _model.textController!.text.trim().isNotEmpty;
    if (canSend != _canSend) {
      setState(() {
        _canSend = canSend;
      });
    }
  }

  @override
  void dispose() {
    _model.textController?.removeListener(_onTextChanged);
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupsRecord>(
      stream: GroupsRecord.getDocument(widget.chatref!),
      builder: (context, snapshot) {
        // Handle error state (e.g., permission denied)
        if (snapshot.hasError) {
          debugPrint('Error loading group: ${snapshot.error}');
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderRadius: 20.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () => context.safePop(),
              ),
              title: Text('Group Chat',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  letterSpacing: 0.0,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: FlutterFlowTheme.of(context).error,
                      size: 64.0,
                    ),
                    SizedBox(height: 16.0),
                    Text('Unable to load group',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        letterSpacing: 0.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('You may not have permission to view this group chat.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    FFButtonWidget(
                      onPressed: () => context.safePop(),
                      text: ffTranslate(context, 'Go Back'),
                      options: FFButtonOptions(
                        height: 44.0,
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        // Show loading indicator while waiting for data
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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

        final groupsRecord = snapshot.data!;

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
                borderRadius: 20.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  context.safePop();
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(
                          groupsRecord.groupimage.isNotEmpty
                              ? groupsRecord.groupimage
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
                          Text(
                            groupsRecord.groupName,
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('${groupsRecord.userid.length} members',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
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
                    Icons.person_add,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: _AddGroupMembersDialog(
                              groupRef: widget.chatref!,
                              currentMembers: groupsRecord.userid,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                FlutterFlowIconButton(
                  borderRadius: 20.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.settings,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: _GroupSettingsDialog(
                              groupRef: widget.chatref!,
                              groupsRecord: groupsRecord,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Messages list
                  Expanded(
                    child: StreamBuilder<List<Chats2Record>>(
                      stream: queryChats2Record(
                        parent: widget.chatref,
                        queryBuilder: (chats2Record) =>
                            chats2Record.orderBy('timestamp', descending: true),
                      ),
                      builder: (context, snapshot) {
                        // Handle error state (e.g., permission denied)
                        if (snapshot.hasError) {
                          debugPrint('Error loading messages: ${snapshot.error}');
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: FlutterFlowTheme.of(context).error,
                                    size: 48.0,
                                  ),
                                  SizedBox(height: 16.0),
                                  Text('Unable to load messages',
                                    style: FlutterFlowTheme.of(context).titleMedium.override(
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text('You may not have permission to view this chat.',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        // Show loading indicator while waiting for messages
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

                        List<Chats2Record> messagesList = snapshot.data!;

                        if (messagesList.isEmpty) {
                          return const EmptychatWidget();
                        }

                        return ListView.builder(
                          padding: EdgeInsets.all(16.0),
                          reverse: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            final message = messagesList[index];
                            final isCurrentUser = message.uidofsender == currentUserReference;

                            return Dismissible(
                              key: Key(message.reference.id),
                              direction: isCurrentUser ? DismissDirection.endToStart : DismissDirection.none,
                              confirmDismiss: isCurrentUser ? (direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                      title: Text('Delete message?',
                                        style: FlutterFlowTheme.of(context).titleMedium.override(
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      content: Text('This will permanently delete your message.',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text('Cancel',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text('Delete',
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              color: FlutterFlowTheme.of(context).error,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ) ?? false;
                              } : null,
                              onDismissed: (direction) async {
                                try {
                                  await message.reference.delete();
                                  debugPrint('Message deleted successfully');
                                } catch (e) {
                                  debugPrint('Error deleting message: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to delete message',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 2000),
                                      backgroundColor: FlutterFlowTheme.of(context).error,
                                    ),
                                  );
                                }
                              },
                              background: isCurrentUser ? Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                                color: FlutterFlowTheme.of(context).error.withValues(alpha: 0.8),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ) : Container(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                  // Sender name and time
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        isCurrentUser ? 0.0 : 48.0,
                                        0.0,
                                        isCurrentUser ? 48.0 : 0.0,
                                        4.0),
                                    child: Text('${message.nameofsender} • ${TimestampFormatter.formatChatTime(message.timestamp)}',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                            fontSize: 11.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                          ),
                                    ),
                                  ),
                                  // Message bubble row
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: isCurrentUser
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Avatar for other users (left side)
                                      if (!isCurrentUser)
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                          child: Container(
                                            width: 32.0,
                                            height: 32.0,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).secondaryBackground,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                      // Message bubble with long press delete
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onLongPress: isCurrentUser ? () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                                title: Text('Delete message?',
                                                  style: FlutterFlowTheme.of(context).titleMedium.override(
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                                content: Text('This will permanently delete your message.',
                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: Text('Cancel',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                        letterSpacing: 0.0,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: Text('Delete',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                        color: FlutterFlowTheme.of(context).error,
                                                        letterSpacing: 0.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ?? false;
                                          if (confirmed) {
                                            try {
                                              await message.reference.delete();
                                              debugPrint('Message deleted successfully');
                                            } catch (e) {
                                              debugPrint('Error deleting message: $e');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Failed to delete message',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  duration: Duration(milliseconds: 2000),
                                                  backgroundColor: FlutterFlowTheme.of(context).error,
                                                ),
                                              );
                                            }
                                          }
                                        } : null,
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: 280.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isCurrentUser
                                                ? FlutterFlowTheme.of(context).primary
                                                : FlutterFlowTheme.of(context).secondaryBackground,
                                            borderRadius: BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              message.message,
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                    ),
                                                    color: isCurrentUser
                                                        ? FlutterFlowTheme.of(context).info
                                                        : FlutterFlowTheme.of(context).primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Avatar for current user (right side)
                                      if (isCurrentUser)
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                          child: AuthUserStreamWidget(
                                            builder: (context) => Container(
                                              width: 32.0,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                image: currentUserPhoto.isNotEmpty
                                                    ? DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: Image.network(currentUserPhoto).image,
                                                      )
                                                    : null,
                                                shape: BoxShape.circle,
                                              ),
                                              child: currentUserPhoto.isEmpty
                                                  ? Icon(
                                                      Icons.person,
                                                      color: FlutterFlowTheme.of(context).secondaryText,
                                                      size: 20.0,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                          },
                        );
                      },
                    ),
                  ),
                  // Message input area
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: ffTranslate(context, 'Type a message...'),
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).alternate,
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
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                              maxLines: 4,
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              cursorColor: FlutterFlowTheme.of(context).primary,
                              validator: _model.textControllerValidator.asValidator(context),
                            ),
                          ),
                          SizedBox(width: 12.0),
                          FlutterFlowIconButton(
                            borderRadius: 24.0,
                            buttonSize: 48.0,
                            fillColor: _canSend 
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).alternate,
                            disabledColor: FlutterFlowTheme.of(context).alternate,
                            disabledIconColor: FlutterFlowTheme.of(context).secondaryText,
                            icon: Icon(
                              Icons.send_rounded,
                              color: _canSend 
                                  ? FlutterFlowTheme.of(context).info
                                  : FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            onPressed: !_canSend
                                ? null
                                : () async {
                                    if (_model.textController.text.trim().isEmpty) {
                                      return;
                                    }

                                    final messageText = _model.textController!.text.trim();
                                    if (messageText.isEmpty) return;
                                    
                                    // Clear the text field immediately for better UX
                                    _model.textController?.clear();
                                    
                                    try {
                                      debugPrint('Sending message to group: ${widget.chatref?.path}');
                                      debugPrint('Current user: ${currentUserReference?.path}');
                                      debugPrint('Display name: $currentUserDisplayName');
                                      
                                      // Create a new message in the Chats2 subcollection
                                      await Chats2Record.createDoc(widget.chatref!).set(
                                        createChats2RecordData(
                                          message: messageText,
                                          timestamp: getCurrentTimestamp,
                                          uidofsender: currentUserReference,
                                          nameofsender: currentUserDisplayName.isNotEmpty 
                                              ? currentUserDisplayName 
                                              : 'User',
                                        ),
                                      );
                                      
                                      debugPrint('Message sent successfully');

                                      // Update the group's last message
                                      await widget.chatref!.update({
                                        'Lastmessage': messageText,
                                        'timestamp': FieldValue.serverTimestamp(),
                                      });
                                      
                                      debugPrint('Group last message updated');
                                    } catch (e) {
                                      debugPrint('Error sending message: $e');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to send message: ${e.toString()}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          duration: Duration(milliseconds: 4000),
                                          backgroundColor: FlutterFlowTheme.of(context).error,
                                        ),
                                      );
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Dialog for group settings (rename, manage admins)
class _GroupSettingsDialog extends StatefulWidget {
  const _GroupSettingsDialog({
    required this.groupRef,
    required this.groupsRecord,
  });

  final DocumentReference groupRef;
  final GroupsRecord groupsRecord;

  @override
  State<_GroupSettingsDialog> createState() => _GroupSettingsDialogState();
}

class _GroupSettingsDialogState extends State<_GroupSettingsDialog> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.groupsRecord.groupName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool _isUserAdmin(DocumentReference? userRef) {
    if (userRef == null) return false;
    if (widget.groupsRecord.adminId == userRef) return true;
    if (widget.groupsRecord.adminIds.contains(userRef)) return true;
    return false;
  }

  bool get _isCurrentUserAdmin => _isUserAdmin(currentUserReference);

  Future<void> _renameGroup() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group name cannot be empty', style: TextStyle(color: Colors.white)),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.groupRef.update({'GroupName': newName});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group renamed successfully', style: TextStyle(color: FlutterFlowTheme.of(context).primaryText)),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      debugPrint('Error renaming group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to rename group', style: TextStyle(color: Colors.white)),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addAdmin(DocumentReference userRef) async {
    setState(() => _isLoading = true);
    try {
      await widget.groupRef.update({
        'adminIds': FieldValue.arrayUnion([userRef]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Admin added successfully', style: TextStyle(color: FlutterFlowTheme.of(context).primaryText)),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      debugPrint('Error adding admin: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add admin', style: TextStyle(color: Colors.white)),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeAdmin(DocumentReference userRef) async {
    if (userRef == widget.groupsRecord.adminId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot remove the group creator as admin', style: TextStyle(color: Colors.white)),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.groupRef.update({
        'adminIds': FieldValue.arrayRemove([userRef]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Admin removed successfully', style: TextStyle(color: FlutterFlowTheme.of(context).primaryText)),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      debugPrint('Error removing admin: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove admin', style: TextStyle(color: Colors.white)),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GroupsRecord>(
      stream: GroupsRecord.getDocument(widget.groupRef),
      builder: (context, snapshot) {
        final groupsRecord = snapshot.data ?? widget.groupsRecord;

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(Icons.close, color: FlutterFlowTheme.of(context).primaryText, size: 24.0),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Group Settings',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 40.0),
                  ],
                ),
              ),
              Divider(height: 1.0, color: FlutterFlowTheme.of(context).alternate),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Group Name Section
                      Text('Group Name',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              enabled: _isCurrentUserAdmin,
                              decoration: InputDecoration(
                                hintText: ffTranslate(context, 'Enter group name'),
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).primary, width: 1.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(),
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                          if (_isCurrentUserAdmin) ...[
                            SizedBox(width: 12.0),
                            FFButtonWidget(
                              onPressed: _isLoading ? null : _renameGroup,
                              text: ffTranslate(context, 'Save'),
                              options: FFButtonOptions(
                                height: 48.0,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!_isCurrentUserAdmin)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text('Only admins can rename the group',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                      SizedBox(height: 24.0),
                      // Members & Admins Section
                      Text('Members & Admins',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('${groupsRecord.userid.length} members',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      // Members list
                      _buildMembersList(groupsRecord),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary),
                    backgroundColor: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembersList(GroupsRecord groupsRecord) {
    if (groupsRecord.userid.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No members in this group',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(),
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
      );
    }

    return FutureBuilder<List<DocumentSnapshot>>(
      future: Future.wait(groupsRecord.userid.map((ref) => ref.get()).toList()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: FFShimmerLoadingIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).primary),
              ),
            ),
          );
        }

        final memberDocs = snapshot.data!;

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: memberDocs.length,
          separatorBuilder: (_, __) => Divider(height: 1.0, color: FlutterFlowTheme.of(context).alternate),
          itemBuilder: (context, index) {
            final doc = memberDocs[index];
            final data = doc.data() as Map<String, dynamic>?;
            if (data == null) return SizedBox.shrink();

            final memberRef = doc.reference;
            final displayName = data['display_name'] as String? ?? 'User';
            final email = data['email'] as String? ?? '';
            final photoUrl = data['photo_url'] as String? ?? '';
            final isAdmin = _isUserAdmin(memberRef);
            final isCreator = groupsRecord.adminId == memberRef;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      image: photoUrl.isNotEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(photoUrl).image,
                            )
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: photoUrl.isEmpty
                        ? Icon(Icons.person, color: FlutterFlowTheme.of(context).secondaryText, size: 24.0)
                        : null,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isAdmin) ...[
                              SizedBox(width: 8.0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: isCreator 
                                    ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2)
                                    : FlutterFlowTheme.of(context).secondary.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  isCreator ? 'Creator' : 'Admin',
                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                    color: isCreator 
                                      ? FlutterFlowTheme.of(context).primary 
                                      : FlutterFlowTheme.of(context).secondary,
                                    fontSize: 10.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  // Admin toggle (only visible to admins, not for themselves or the creator)
                  if (_isCurrentUserAdmin && memberRef != currentUserReference && !isCreator)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: FlutterFlowTheme.of(context).secondaryText),
                      onSelected: (value) async {
                        if (value == 'make_admin') {
                          await _addAdmin(memberRef);
                        } else if (value == 'remove_admin') {
                          await _removeAdmin(memberRef);
                        }
                      },
                      itemBuilder: (context) => [
                        if (!isAdmin)
                          PopupMenuItem(
                            value: 'make_admin',
                            child: Row(
                              children: [
                                Icon(Icons.admin_panel_settings, color: FlutterFlowTheme.of(context).primary, size: 20.0),
                                SizedBox(width: 8.0),
                                Text('Make Admin', style: FlutterFlowTheme.of(context).bodyMedium.override(letterSpacing: 0.0)),
                              ],
                            ),
                          )
                        else
                          PopupMenuItem(
                            value: 'remove_admin',
                            child: Row(
                              children: [
                                Icon(Icons.remove_moderator, color: FlutterFlowTheme.of(context).error, size: 20.0),
                                SizedBox(width: 8.0),
                                Text('Remove Admin', style: FlutterFlowTheme.of(context).bodyMedium.override(color: FlutterFlowTheme.of(context).error, letterSpacing: 0.0)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Dialog for adding members to an existing group
class _AddGroupMembersDialog extends StatefulWidget {
  const _AddGroupMembersDialog({
    required this.groupRef,
    required this.currentMembers,
  });

  final DocumentReference groupRef;
  final List<DocumentReference> currentMembers;

  @override
  State<_AddGroupMembersDialog> createState() => _AddGroupMembersDialogState();
}

class _AddGroupMembersDialogState extends State<_AddGroupMembersDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentReference> _selectedMembers = [];
  bool _isSearchActive = false;
  List<UsersRecord> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(List<UsersRecord> allUsers) {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _isSearchActive = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearchActive = true;
      _searchResults = allUsers.where((user) {
        final name = user.displayName.toLowerCase();
        final email = user.email.toLowerCase();
        return name.contains(query) || email.contains(query);
      }).toList();
    });
  }

  Future<void> _addMembers() async {
    if (_selectedMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one member',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    try {
      // Get the selected users' names
      final selectedUsersData = await Future.wait(
        _selectedMembers.map((ref) => ref.get()),
      );

      final selectedUsernames = selectedUsersData
          .map((doc) => (doc.data() as Map<String, dynamic>)['display_name'] as String? ?? 'User')
          .toList();

      // Update the group document
      await widget.groupRef.update({
        'userid': FieldValue.arrayUnion(_selectedMembers),
        'usernames': FieldValue.arrayUnion(selectedUsernames),
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Members added successfully',
            style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    } catch (e) {
      debugPrint('Error adding members: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add members',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(milliseconds: 2000),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsersRecord>>(
      stream: queryUsersRecord(
        queryBuilder: (usersRecord) =>
            usersRecord.orderBy('display_name', descending: false),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Center(
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

        // Filter out users who are already members and the current user
        final availableUsers = snapshot.data!.where((user) {
          return !widget.currentMembers.contains(user.reference) &&
              user.uid != currentUserUid;
        }).toList();

        final usersToDisplay = _isSearchActive ? _searchResults : availableUsers;

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text('Add Members',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
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
                      onPressed: _addMembers,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                // Search field
                TextFormField(
                  controller: _searchController,
                  onChanged: (_) => _performSearch(availableUsers),
                  decoration: InputDecoration(
                    hintText: ffTranslate(context, 'Search users...'),
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _searchController.clear();
                              _performSearch(availableUsers);
                            },
                            child: Icon(
                              Icons.clear,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          )
                        : null,
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
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                SizedBox(height: 16.0),
                // Selected members count
                if (_selectedMembers.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text('${_selectedMembers.length} member(s) selected',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                // User list
                Expanded(
                  child: usersToDisplay.isEmpty
                      ? Center(
                          child: Text(
                            _isSearchActive
                                ? 'No users found'
                                : 'No available users to add',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: usersToDisplay.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          itemBuilder: (context, index) {
                            final user = usersToDisplay[index];
                            final isSelected = _selectedMembers.contains(user.reference);

                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedMembers.remove(user.reference);
                                  } else {
                                    _selectedMembers.add(user.reference);
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        image: user.photoUrl.isNotEmpty
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.network(user.photoUrl).image,
                                              )
                                            : null,
                                        shape: BoxShape.circle,
                                      ),
                                      child: user.photoUrl.isEmpty
                                          ? Icon(
                                              Icons.person,
                                              color: FlutterFlowTheme.of(context).secondaryText,
                                              size: 24.0,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.displayName.isNotEmpty
                                                ? user.displayName
                                                : 'User',
                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          if (user.email.isNotEmpty)
                                            Text(
                                              user.email,
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight: FlutterFlowTheme.of(context).bodySmall.fontWeight,
                                                      fontStyle: FlutterFlowTheme.of(context).bodySmall.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedMembers.add(user.reference);
                                          } else {
                                            _selectedMembers.remove(user.reference);
                                          }
                                        });
                                      },
                                      activeColor: FlutterFlowTheme.of(context).primary,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
