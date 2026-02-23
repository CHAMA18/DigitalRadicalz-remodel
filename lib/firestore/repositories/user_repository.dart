import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/users_record.dart';
import '/firestore/firestore_data_schema.dart';

/// Repository for managing user data with Firestore
/// Implements security-aware queries and proper error handling
class UserRepository extends FirestoreRepository<UsersRecord> {
  UserRepository() : super(FirestoreDataSchema.usersCollection);

  @override
  UsersRecord fromFirestore(DocumentSnapshot doc) {
    return UsersRecord.fromSnapshot(doc);
  }

  @override
  Map<String, dynamic> toFirestore(UsersRecord model) {
    return createUsersRecordData(
      email: model.email,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
      uid: model.uid,
      phoneNumber: model.phoneNumber,
      allNotifications: model.allNotifications,
      recommendedNotifications: model.recommendedNotifications,
      communityPostsNotifications: model.communityPostsNotifications,
      walletBalance: model.walletBalance,
      userType: model.userType,
      addressname: model.addressname,
      addressnumber: model.addressnumber,
      town: model.town,
      birthday: model.birthday,
      numberofticket: model.numberofticket,
      communityjoined: model.communityjoined,
    );
  }

  /// Create a new user profile
  /// Only the authenticated user can create their own profile
  Future<DocumentReference> createUserProfile({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    final userData = FirestoreDataSchema.getUserSchema(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
    );

    // Use the UID as the document ID for user profiles
    final userDoc = collection.doc(uid);
    await userDoc.set(userData);
    return userDoc;
  }

  /// Get current user's profile by UID
  Future<UsersRecord?> getCurrentUserProfile(String uid) async {
    try {
      final doc = await collection.doc(uid).get();
      if (doc.exists) {
        return UsersRecord.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  /// Stream current user's profile changes
  Stream<UsersRecord?> watchCurrentUserProfile(String uid) {
    return collection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UsersRecord.fromSnapshot(doc);
      }
      return null;
    });
  }

  /// Update user interests
  Future<void> updateUserInterests(String uid, List<String> interests) async {
    await collection.doc(uid).update({
      'interests': interests,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update notification preferences
  Future<void> updateNotificationSettings(
    String uid, {
    bool? allNotifications,
    bool? recommendedNotifications,
    bool? communityPostsNotifications,
  }) async {
    final Map<String, dynamic> updates = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (allNotifications != null) {
      updates['allNotifications'] = allNotifications;
    }
    if (recommendedNotifications != null) {
      updates['recommendedNotifications'] = recommendedNotifications;
    }
    if (communityPostsNotifications != null) {
      updates['communityPostsNotifications'] = communityPostsNotifications;
    }

    await collection.doc(uid).update(updates);
  }

  /// Update wallet balance
  Future<void> updateWalletBalance(String uid, double newBalance) async {
    await collection.doc(uid).update({
      'walletBalance': newBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Add money to wallet (atomic transaction)
  Future<void> addToWallet(String uid, double amount) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDoc = collection.doc(uid);
      final snapshot = await transaction.get(userDoc);

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>? ?? {};
        final currentBalance = data['walletBalance'] as double? ?? 0.0;
        final newBalance = currentBalance + amount;

        transaction.update(userDoc, {
          'walletBalance': newBalance,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Follow another user
  Future<void> followUser(String currentUserId, DocumentReference targetUserRef) async {
    await collection.doc(currentUserId).update({
      'following': FieldValue.arrayUnion([targetUserRef]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Unfollow a user
  Future<void> unfollowUser(String currentUserId, DocumentReference targetUserRef) async {
    await collection.doc(currentUserId).update({
      'following': FieldValue.arrayRemove([targetUserRef]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Join a community
  Future<void> joinCommunity(String userId, DocumentReference communityRef) async {
    await collection.doc(userId).update({
      'communityjoined': communityRef,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Like an event
  Future<void> likeEvent(String userId, DocumentReference eventRef) async {
    await collection.doc(userId).update({
      'eventliked': FieldValue.arrayUnion([eventRef]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Unlike an event
  Future<void> unlikeEvent(String userId, DocumentReference eventRef) async {
    await collection.doc(userId).update({
      'eventliked': FieldValue.arrayRemove([eventRef]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update user profile information
  Future<void> updateProfile(
    String uid, {
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? addressname,
    String? addressnumber,
    String? town,
    DateTime? birthday,
  }) async {
    final Map<String, dynamic> updates = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (displayName != null) updates['display_name'] = displayName;
    if (photoUrl != null) updates['photo_url'] = photoUrl;
    if (phoneNumber != null) updates['phone_number'] = phoneNumber;
    if (addressname != null) updates['addressname'] = addressname;
    if (addressnumber != null) updates['addressnumber'] = addressnumber;
    if (town != null) updates['Town'] = town;
    if (birthday != null) updates['Birthday'] = birthday;

    await collection.doc(uid).update(updates);
  }
}