import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/firestore/repositories/user_repository.dart';
import '/firestore/repositories/product_repository.dart';

/// Centralized service for managing Firestore operations
/// Provides a single entry point for all data operations
class FirestoreService {
  static FirestoreService? _instance;
  
  // Repository instances
  late final UserRepository _userRepository;
  late final ProductRepository _productRepository;

  FirestoreService._() {
    _userRepository = UserRepository();
    _productRepository = ProductRepository();
  }

  /// Singleton instance
  static FirestoreService get instance {
    _instance ??= FirestoreService._();
    return _instance!;
  }

  // Repository getters
  UserRepository get users => _userRepository;
  ProductRepository get products => _productRepository;

  /// Initialize user data after authentication
  Future<void> initializeUserData({
    required String uid,
    required String email,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _userRepository.getCurrentUserProfile(uid);
      
      if (existingUser == null) {
        // Create new user profile
        await _userRepository.createUserProfile(
          uid: uid,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
          phoneNumber: phoneNumber,
        );
        print('User profile created for $uid');
      } else {
        // Update existing user data if needed
        final Map<String, dynamic> updates = {};
        
        if (existingUser.email != email) updates['email'] = email;
        if (existingUser.displayName != displayName) updates['display_name'] = displayName;
        if (photoUrl != null && existingUser.photoUrl != photoUrl) {
          updates['photo_url'] = photoUrl;
        }
        
        if (updates.isNotEmpty) {
          updates['updatedAt'] = FieldValue.serverTimestamp();
          await _userRepository.update(uid, updates);
          print('User profile updated for $uid');
        }
      }
    } catch (e) {
      print('Error initializing user data: $e');
      rethrow;
    }
  }

  /// Get current user profile with error handling
  Future<dynamic> getCurrentUserProfile() async {
    try {
      final uid = currentUserUid;
      if (uid == null || uid.isEmpty) {
        print('No authenticated user found');
        return null;
      }

      return await _userRepository.getCurrentUserProfile(uid);
    } catch (e) {
      print('Error getting current user profile: $e');
      return null;
    }
  }

  /// Stream current user profile changes
  Stream<dynamic> watchCurrentUserProfile() {
    final uid = currentUserUid;
    if (uid == null || uid.isEmpty) {
      return Stream.value(null);
    }

    return _userRepository.watchCurrentUserProfile(uid);
  }

  /// Search and filter products with caching
  Future<List<dynamic>> searchProducts({
    String? category,
    String? searchTerm,
    double? minPrice,
    double? maxPrice,
    int limit = 20,
  }) async {
    try {
      if (category == null) {
        return await _productRepository.getAllProducts(limit: limit);
      }

      if (searchTerm != null && searchTerm.isNotEmpty) {
        return await _productRepository.searchProductsByName(
          category,
          searchTerm,
          limit: limit,
        );
      }

      if (minPrice != null || maxPrice != null) {
        return await _productRepository.getProductsByPriceRange(
          category,
          minPrice: minPrice,
          maxPrice: maxPrice,
          limit: limit,
        );
      }

      return await _productRepository.getProductsByCategory(
        category,
        limit: limit,
      );
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  /// Batch operations for better performance
  Future<void> executeBatch(List<BatchOperation> operations) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      for (final operation in operations) {
        switch (operation.type) {
          case BatchOperationType.create:
            batch.set(operation.reference, operation.data!);
            break;
          case BatchOperationType.update:
            batch.update(operation.reference, operation.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(operation.reference);
            break;
        }
      }

      await batch.commit();
      print('Batch operation completed with ${operations.length} operations');
    } catch (e) {
      print('Error executing batch operations: $e');
      rethrow;
    }
  }

  /// Health check for Firestore connection
  Future<bool> checkConnection() async {
    try {
      await FirebaseFirestore.instance
          .collection('health_check')
          .doc('test')
          .get();
      return true;
    } catch (e) {
      print('Firestore connection failed: $e');
      return false;
    }
  }

  /// Clear local cache (useful for testing)
  Future<void> clearCache() async {
    try {
      await FirebaseFirestore.instance.clearPersistence();
      print('Firestore cache cleared');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Enable/disable offline persistence
  Future<void> setOfflinePersistence(bool enabled) async {
    try {
      if (enabled) {
        await FirebaseFirestore.instance.enableNetwork();
      } else {
        await FirebaseFirestore.instance.disableNetwork();
      }
      print('Offline persistence ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      print('Error setting offline persistence: $e');
    }
  }

  /// Toggle like on a Post document using a transaction (one-like-per-user).
  /// Returns the new liked state (true if liked after the operation).
  Future<bool> togglePostLikeTransactional(
    DocumentReference postRef,
    DocumentReference userRef,
  ) async {
    try {
      return await FirebaseFirestore.instance.runTransaction<bool>((tx) async {
        final snap = await tx.get(postRef);
        if (!snap.exists) throw Exception('Post not found');
        final data = snap.data() as Map<String, dynamic>? ?? {};
        final List<dynamic> current = (data['Posted_likeby'] as List?) ?? <dynamic>[];
        final bool alreadyLiked = current.any((e) => e is DocumentReference && e.path == userRef.path);

        final update = alreadyLiked
            ? FieldValue.arrayRemove([userRef])
            : FieldValue.arrayUnion([userRef]);

        tx.update(postRef, {'Posted_likeby': update});
        return !alreadyLiked;
      });
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }
}

/// Batch operation helper class
class BatchOperation {
  final BatchOperationType type;
  final DocumentReference reference;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.reference,
    this.data,
  });

  static BatchOperation create(DocumentReference ref, Map<String, dynamic> data) {
    return BatchOperation(
      type: BatchOperationType.create,
      reference: ref,
      data: data,
    );
  }

  static BatchOperation update(DocumentReference ref, Map<String, dynamic> data) {
    return BatchOperation(
      type: BatchOperationType.update,
      reference: ref,
      data: data,
    );
  }

  static BatchOperation delete(DocumentReference ref) {
    return BatchOperation(
      type: BatchOperationType.delete,
      reference: ref,
    );
  }
}

enum BatchOperationType { create, update, delete }

/// Error handling wrapper for Firestore operations
class FirestoreError {
  final String code;
  final String message;
  final dynamic originalError;

  FirestoreError({
    required this.code,
    required this.message,
    this.originalError,
  });

  static FirestoreError fromException(dynamic e) {
    if (e is FirebaseException) {
      return FirestoreError(
        code: e.code,
        message: e.message ?? 'Unknown Firebase error',
        originalError: e,
      );
    }
    
    return FirestoreError(
      code: 'unknown',
      message: e.toString(),
      originalError: e,
    );
  }

  bool get isNetworkError => code == 'unavailable';
  bool get isPermissionDenied => code == 'permission-denied';
  bool get isNotFound => code == 'not-found';
}