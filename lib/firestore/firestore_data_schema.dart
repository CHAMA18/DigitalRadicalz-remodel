import 'package:cloud_firestore/cloud_firestore.dart';

/// Comprehensive Firestore data schema for Bright Wave application
/// This file defines the data structure and relationships for all collections

class FirestoreDataSchema {
  // Collection names as constants
  static const String usersCollection = 'users';
  static const String productsCollection = 'product';
  static const String communitiesCollection = 'communities';
  static const String postsCollection = 'post';
  static const String commentsCollection = 'commentsecction';
  static const String chatsCollection = 'chats';
  static const String chats2Collection = 'chats2';
  static const String chatMessagesCollection = 'chatmessages';
  static const String chatMessagesGroupCollection = 'chatmessagesgroup';
  static const String groupsCollection = 'groups';
  static const String eventsCollection = 'events';
  static const String ticketsCollection = 'tickets';
  static const String ticketTypesCollection = 'ticket_types';
  static const String ordersCollection = 'orders';
  static const String orders2Collection = 'orders2';
  static const String orderItemsCollection = 'order_items';
  static const String cartCollection = 'cart';
  static const String coursesCollection = 'course';
  static const String courseModulesCollection = 'coursemodules';
  static const String newsCollection = 'news';
  static const String communityMembershipsCollection = 'community_memberships';

  /// Users collection schema
  /// Path: /users/{userId}
  /// Security: Private - users can only access their own data
  static Map<String, dynamic> getUserSchema({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
    List<String>? interests,
    bool allNotifications = false,
    bool recommendedNotifications = false,
    bool communityPostsNotifications = false,
    double walletBalance = 0.0,
    String userType = 'user',
    String? addressname,
    String? addressnumber,
    String? town,
    DateTime? birthday,
    int numberofticket = 0,
    List<DocumentReference>? following,
    DocumentReference? communityjoined,
    List<DocumentReference>? eventliked,
    List<DocumentReference>? interestss,
  }) {
    return {
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'created_time': FieldValue.serverTimestamp(),
      'interests': interests ?? [],
      'allNotifications': allNotifications,
      'recommendedNotifications': recommendedNotifications,
      'communityPostsNotifications': communityPostsNotifications,
      'walletBalance': walletBalance,
      'userType': userType,
      'addressname': addressname,
      'addressnumber': addressnumber,
      'Town': town,
      'Birthday': birthday,
      'numberofticket': numberofticket,
      'following': following ?? [],
      'communityjoined': communityjoined,
      'eventliked': eventliked ?? [],
      'interestss': interestss ?? [],
    };
  }

  /// Products collection schema
  /// Path: /product/{productId}
  /// Security: Public read, admin write
  static Map<String, dynamic> getProductSchema({
    required String name,
    required double price,
    required String image,
    required String description,
    required int quantity,
    required String category,
    String? ownerId,
  }) {
    return {
      'Name': name,
      'Price': price,
      'Image': image,
      'Description': description,
      'Quantity': quantity,
      'Date': FieldValue.serverTimestamp(),
      'Category': category,
      'owner_id': ownerId,
    };
  }

  /// Communities collection schema
  /// Path: /communities/{communityId}
  /// Security: Public read, authenticated users can create/write
  static Map<String, dynamic> getCommunitySchema({
    required String name,
    required String description,
    required String image,
    required String category,
    int membercount = 0,
    bool ispublic = true,
    String? createdBy,
  }) {
    return {
      'communityid': '', // Will be set by document ID
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'membercount': membercount,
      'ispublic': ispublic,
      'createdBy': createdBy,
      'created_time': FieldValue.serverTimestamp(),
    };
  }

  /// Posts collection schema
  /// Path: /post/{postId}
  /// Security: Public read, authenticated users can create, owners can modify
  static Map<String, dynamic> getPostSchema({
    required String userId,
    required String content,
    String? communityId,
    String? imageUrl,
    List<String>? tags,
    int likesCount = 0,
    int commentsCount = 0,
  }) {
    return {
      'userId': userId,
      'content': content,
      'communityId': communityId,
      'imageUrl': imageUrl,
      'tags': tags ?? [],
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Comments collection schema
  /// Path: /commentsecction/{commentId}
  /// Security: Authenticated users only
  static Map<String, dynamic> getCommentSchema({
    required String userId,
    required String postId,
    required String content,
    String? parentCommentId,
  }) {
    return {
      'userId': userId,
      'postId': postId,
      'content': content,
      'parentCommentId': parentCommentId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Chat messages schema
  /// Path: /chatmessages/{messageId}
  /// Security: Participants only
  static Map<String, dynamic> getChatMessageSchema({
    required String senderId,
    required String chatId,
    required String message,
    String messageType = 'text',
    String? imageUrl,
  }) {
    return {
      'senderId': senderId,
      'chatId': chatId,
      'message': message,
      'messageType': messageType,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  /// Group messages schema
  /// Path: /chatmessagesgroup/{messageId}
  /// Security: Group members only
  static Map<String, dynamic> getGroupMessageSchema({
    required String senderId,
    required String groupId,
    required String message,
    String messageType = 'text',
    String? imageUrl,
  }) {
    return {
      'senderId': senderId,
      'groupId': groupId,
      'message': message,
      'messageType': messageType,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  /// Events collection schema
  /// Path: /events/{eventId}
  /// Security: Public read, authenticated users can create
  static Map<String, dynamic> getEventSchema({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String location,
    required String createdBy,
    String? imageUrl,
    String? category,
    bool isPublic = true,
    double? ticketPrice,
    int maxAttendees = 0,
  }) {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
      'category': category,
      'isPublic': isPublic,
      'ticketPrice': ticketPrice,
      'maxAttendees': maxAttendees,
      'attendeesCount': 0,
      'created_time': FieldValue.serverTimestamp(),
    };
  }

  /// Orders collection schema
  /// Path: /orders/{orderId}
  /// Security: Users can manage their own orders
  static Map<String, dynamic> getOrderSchema({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    String status = 'pending',
    String? shippingAddress,
    String? paymentMethod,
  }) {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'orderDate': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Cart collection schema
  /// Path: /cart/{cartId}
  /// Security: Users can manage their own cart
  static Map<String, dynamic> getCartSchema({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Tickets collection schema
  /// Path: /tickets/{ticketId}
  /// Security: Users can manage their own tickets
  static Map<String, dynamic> getTicketSchema({
    required String userId,
    required String eventId,
    required String ticketType,
    required double price,
    String status = 'active',
    String? qrCode,
  }) {
    return {
      'userId': userId,
      'eventId': eventId,
      'ticketType': ticketType,
      'price': price,
      'status': status,
      'qrCode': qrCode,
      'purchaseDate': FieldValue.serverTimestamp(),
    };
  }

  /// News collection schema
  /// Path: /news/{newsId}
  /// Security: Public read, admin write
  static Map<String, dynamic> getNewsSchema({
    required String title,
    required String content,
    required String authorId,
    String? imageUrl,
    String? category,
    bool isPublished = true,
    List<String>? tags,
  }) {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'imageUrl': imageUrl,
      'category': category,
      'isPublished': isPublished,
      'tags': tags ?? [],
      'publishedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Community memberships collection schema
  /// Path: /community_memberships/{membershipId}
  /// Security: Users can manage their own memberships
  static Map<String, dynamic> getCommunityMembershipSchema({
    required String userId,
    required String communityId,
    String role = 'member',
    bool isActive = true,
  }) {
    return {
      'userId': userId,
      'communityId': communityId,
      'role': role,
      'isActive': isActive,
      'joinedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Common query helpers
  static Query getUserPosts(String userId) {
    return FirebaseFirestore.instance
        .collection(postsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);
  }

  static Query getCommunityPosts(String communityId) {
    return FirebaseFirestore.instance
        .collection(postsCollection)
        .where('communityId', isEqualTo: communityId)
        .orderBy('createdAt', descending: true);
  }

  static Query getProductsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection(productsCollection)
        .where('Category', isEqualTo: category)
        .orderBy('Date', descending: true);
  }

  static Query getUserOrders(String userId) {
    return FirebaseFirestore.instance
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true);
  }

  static Query getChatMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection(chatMessagesCollection)
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false);
  }

  static Query getGroupMessages(String groupId) {
    return FirebaseFirestore.instance
        .collection(chatMessagesGroupCollection)
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: false);
  }

  static Query getPublicCommunities() {
    return FirebaseFirestore.instance
        .collection(communitiesCollection)
        .where('ispublic', isEqualTo: true)
        .orderBy('membercount', descending: true);
  }

  static Query getUpcomingEvents() {
    return FirebaseFirestore.instance
        .collection(eventsCollection)
        .where('startDate', isGreaterThan: DateTime.now())
        .where('isPublic', isEqualTo: true)
        .orderBy('startDate', descending: false);
  }

  static Query getPublishedNews() {
    return FirebaseFirestore.instance
        .collection(newsCollection)
        .where('isPublished', isEqualTo: true)
        .orderBy('publishedAt', descending: true);
  }

  /// Batch operations helpers
  static WriteBatch createBatch() {
    return FirebaseFirestore.instance.batch();
  }

  /// Transaction helper
  static Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) {
    return FirebaseFirestore.instance.runTransaction(updateFunction);
  }
}

/// Repository pattern base class for Firestore operations
abstract class FirestoreRepository<T> {
  final String collectionPath;
  final CollectionReference collection;

  FirestoreRepository(this.collectionPath)
      : collection = FirebaseFirestore.instance.collection(collectionPath);

  /// Convert Firestore document to model
  T fromFirestore(DocumentSnapshot doc);

  /// Convert model to Firestore data
  Map<String, dynamic> toFirestore(T model);

  /// Get document by ID
  Future<T?> getById(String id) async {
    final doc = await collection.doc(id).get();
    if (doc.exists) {
      return fromFirestore(doc);
    }
    return null;
  }

  /// Create new document
  Future<DocumentReference> create(T model) async {
    final data = toFirestore(model);
    return await collection.add(data);
  }

  /// Update existing document
  Future<void> update(String id, Map<String, dynamic> updates) async {
    updates['updatedAt'] = FieldValue.serverTimestamp();
    await collection.doc(id).update(updates);
  }

  /// Delete document
  Future<void> delete(String id) async {
    await collection.doc(id).delete();
  }

  /// Stream document changes
  Stream<T?> watchById(String id) {
    return collection.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return fromFirestore(doc);
      }
      return null;
    });
  }

  /// Stream query results
  Stream<List<T>> watchQuery(Query query) {
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
    });
  }
}