import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

double totalPrice(
  double pice,
  int quantity,
  double fee,
) {
  // to calculate the total price of a ticket
  return (pice * quantity) + fee;
}

List<DocumentReference> generateListOfUsers(
  DocumentReference authUser,
  DocumentReference otherUser,
) {
  return [authUser, otherUser];
}

List<String> generateListOfNames(
  String authUserName,
  String otherUserName,
) {
  return [authUserName, otherUserName];
}

DocumentReference getOtherUserRef(
  List<DocumentReference> listOfUserRefs,
  DocumentReference authUserRef,
) {
  if (listOfUserRefs.isEmpty) {
    return authUserRef; // Return auth user ref as fallback
  }
  if (listOfUserRefs.length == 1) {
    return listOfUserRefs.first;
  }
  return authUserRef == listOfUserRefs.first
      ? listOfUserRefs.last
      : listOfUserRefs.first;
}

String getOtherUserName(
  List<String> listOfNames,
  String authUserName,
) {
  if (listOfNames.isEmpty) {
    return authUserName; // Return auth user name as fallback
  }
  if (listOfNames.length == 1) {
    return listOfNames.first;
  }
  return authUserName == listOfNames.first
      ? listOfNames.last
      : listOfNames.first;
}

Future<ChatsRecord?> findExistingChat(
  DocumentReference currentUserRef,
  DocumentReference otherUserRef,
) async {
  // Query for chats containing the current user
  final chatsQuery = await FirebaseFirestore.instance
      .collection('Chats')
      .where('userid', arrayContains: currentUserRef)
      .get();

  // Check each chat to see if it contains both users and is a 1-on-1 chat
  for (final doc in chatsQuery.docs) {
    final chatData = doc.data();
    final List<dynamic> userIds = chatData['userid'] ?? [];
    
    // Convert to DocumentReference list
    final List<DocumentReference> userRefs = userIds
        .cast<DocumentReference>()
        .toList();
    
    // Check if this is a 1-on-1 chat with the specific other user
    if (userRefs.length == 2 &&
        userRefs.contains(currentUserRef) &&
        userRefs.contains(otherUserRef)) {
      return ChatsRecord.fromSnapshot(doc);
    }
  }
  
  return null;
}

bool chatContainsBothUsers(
  List<DocumentReference> chatUserIds,
  DocumentReference user1,
  DocumentReference user2,
) {
  return chatUserIds.length == 2 &&
         chatUserIds.contains(user1) &&
         chatUserIds.contains(user2);
}

Future<void> removeDuplicateChats(DocumentReference currentUserRef) async {
  try {
    // Get all chats for current user
    final chatsQuery = await FirebaseFirestore.instance
        .collection('Chats')
        .where('userid', arrayContains: currentUserRef)
        .get();

    // Group chats by the other user
    Map<DocumentReference, List<ChatsRecord>> chatsByOtherUser = {};
    
    for (final doc in chatsQuery.docs) {
      final chat = ChatsRecord.fromSnapshot(doc);
      
      // Only handle 1-on-1 chats (2 users)
      if (chat.userid.length == 2) {
        final otherUserRef = chat.userid.firstWhere((ref) => ref != currentUserRef);
        
        if (!chatsByOtherUser.containsKey(otherUserRef)) {
          chatsByOtherUser[otherUserRef] = [];
        }
        chatsByOtherUser[otherUserRef]!.add(chat);
      }
    }

    // Remove duplicates, keeping the most recent chat
    for (final entry in chatsByOtherUser.entries) {
      final duplicateChats = entry.value;
      
      if (duplicateChats.length > 1) {
        // Sort by timestamp, keep the most recent
        duplicateChats.sort((a, b) {
          if (a.timestamp == null && b.timestamp == null) return 0;
          if (a.timestamp == null) return 1;
          if (b.timestamp == null) return -1;
          return b.timestamp!.compareTo(a.timestamp!);
        });
        
        // Delete all but the first (most recent) chat
        for (int i = 1; i < duplicateChats.length; i++) {
          await duplicateChats[i].reference.delete();
          print('DEBUG: Deleted duplicate chat with user ${entry.key.path}');
        }
      }
    }
  } catch (e) {
    print('ERROR: Failed to remove duplicate chats: $e');
  }
}
