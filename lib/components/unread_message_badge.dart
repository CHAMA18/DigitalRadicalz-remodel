import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// A widget that displays an unread message badge on top of a child widget (like a chat icon).
/// It streams the count of unread direct messages and group chats from Firebase.
class UnreadMessageBadge extends StatelessWidget {
  const UnreadMessageBadge({
    super.key,
    required this.child,
    this.showZero = false,
  });

  /// The widget to display (usually an icon)
  final Widget child;

  /// Whether to show the badge when count is zero
  final bool showZero;

  @override
  Widget build(BuildContext context) {
    // Don't show badge if not authenticated
    if (currentUserReference == null) {
      return child;
    }

    return StreamBuilder<int>(
      stream: _getUnreadCountStream(),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;

        // Don't show badge if count is 0 and showZero is false
        if (count == 0 && !showZero) {
          return child;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: EdgeInsets.all(count > 9 ? 3.0 : 4.0),
                constraints: BoxConstraints(
                  minWidth: 18.0,
                  minHeight: 18.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: count > 9 ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: count > 9 ? BorderRadius.circular(9.0) : null,
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Creates a combined stream of unread direct messages and group chats
  Stream<int> _getUnreadCountStream() {
    try {
      // Stream for unread direct messages
      final directMessagesStream = queryChatsRecord(
        queryBuilder: (chatsRecord) => chatsRecord.where(
          'userid',
          arrayContains: currentUserReference,
        ),
      ).handleError((error) {
        debugPrint('Error querying direct chats for unread count: $error');
        return <ChatsRecord>[];
      }).map((chats) {
        int count = 0;
        for (final chat in chats) {
          if (!chat.lastmessageseenby.contains(currentUserReference)) {
            count++;
          }
        }
        return count;
      });

      // Stream for unread group chats
      final groupChatsStream = queryGroupsRecord(
        queryBuilder: (groupsRecord) => groupsRecord.where(
          'userid',
          arrayContains: currentUserReference,
        ),
      ).handleError((error) {
        debugPrint('Error querying group chats for unread count: $error');
        return <GroupsRecord>[];
      }).map((groups) {
        int count = 0;
        for (final group in groups) {
          // Skip placeholder groups
          final name = group.groupName.trim().toLowerCase().replaceAll('!', '');
          if (name == 'say hello') continue;
          
          if (!group.lastmessageseenby.contains(currentUserReference)) {
            count++;
          }
        }
        return count;
      });

      // Combine both streams
      return Rx.combineLatest2<int, int, int>(
        directMessagesStream,
        groupChatsStream,
        (directCount, groupCount) => directCount + groupCount,
      ).handleError((error) {
        debugPrint('Error combining unread count streams: $error');
        return 0;
      });
    } catch (e) {
      debugPrint('Error setting up unread count stream: $e');
      return Stream.value(0);
    }
  }
}

/// A smaller dot indicator for showing unread status without count
class UnreadDotIndicator extends StatelessWidget {
  const UnreadDotIndicator({
    super.key,
    required this.child,
    this.showDot = true,
    this.dotColor,
    this.dotSize = 8.0,
  });

  final Widget child;
  final bool showDot;
  final Color? dotColor;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    if (!showDot) return child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: dotColor ?? FlutterFlowTheme.of(context).primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
