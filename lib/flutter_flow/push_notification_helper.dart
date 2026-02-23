import '/backend/backend.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationHelper {
  // Trigger push notifications for group messages
  static Future<void> sendGroupMessageNotification({
    required GroupsRecord groupRecord,
    required String senderName,
    required String messageText,
    required DocumentReference senderRef,
  }) async {
    try {
      // Get all group members except the sender
      final List<DocumentReference> recipients = groupRecord.userid
          .where((userRef) => userRef != senderRef)
          .toList();

      if (recipients.isNotEmpty) {
        // Create notification payload
        final notificationData = {
          'title': groupRecord.groupName,
          'body': '$senderName: $messageText',
          'data': {
            'type': 'group_message',
            'groupId': groupRecord.reference.id,
            'groupName': groupRecord.groupName,
            'senderId': senderRef.id,
            'senderName': senderName,
          },
          'recipients': recipients.map((ref) => ref.id).toList(),
          'timestamp': FieldValue.serverTimestamp(),
        };

        // Store notification in Firestore (this would be picked up by Cloud Functions)
        await FirebaseFirestore.instance
            .collection('notifications')
            .add(notificationData);
      }
    } catch (e) {
      print('Error sending group message notification: $e');
    }
  }

  // Trigger push notifications for direct chat messages
  static Future<void> sendDirectMessageNotification({
    required ChatsRecord chatRecord,
    required String senderName,
    required String messageText,
    required DocumentReference senderRef,
  }) async {
    try {
      final recipients = chatRecord.userid
          .where((u) => u.id != senderRef.id)
          .map((u) => u.id)
          .toList();

      if (recipients.isEmpty) return;

      final notificationData = {
        'title': senderName,
        'body': messageText,
        'data': {
          'type': 'direct_message',
          'chatId': chatRecord.reference.id,
          'senderId': senderRef.id,
          'senderName': senderName,
        },
        'recipients': recipients,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);
    } catch (e) {
      print('Error sending direct message notification: $e');
    }
  }

  // Trigger push notifications for new group member
  static Future<void> sendNewGroupMemberNotification({
    required GroupsRecord groupRecord,
    required List<DocumentReference> newMembers,
  }) async {
    try {
      if (newMembers.isNotEmpty) {
        // Create notification payload for new members
        final notificationData = {
          'title': 'You were added to ${groupRecord.groupName}',
          'body': 'Welcome to the group!',
          'data': {
            'type': 'group_added',
            'groupId': groupRecord.reference.id,
            'groupName': groupRecord.groupName,
          },
          'recipients': newMembers.map((ref) => ref.id).toList(),
          'timestamp': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('notifications')
            .add(notificationData);
      }
    } catch (e) {
      print('Error sending new group member notification: $e');
    }
  }
}