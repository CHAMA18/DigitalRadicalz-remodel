import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/product_record.dart';
import '/firestore/firestore_data_schema.dart';

/// Repository for managing product data with Firestore
/// Implements category filtering, search, and price-based queries
class ProductRepository extends FirestoreRepository<ProductRecord> {
  ProductRepository() : super(FirestoreDataSchema.productsCollection);

  @override
  ProductRecord fromFirestore(DocumentSnapshot doc) {
    return ProductRecord.fromSnapshot(doc);
  }

  @override
  Map<String, dynamic> toFirestore(ProductRecord model) {
    return {
      'Name': model.name,
      'Price': model.price,
      'Image': model.image,
      'Description': model.description,
      'Quantity': model.quantity,
      'Date': model.date ?? FieldValue.serverTimestamp(),
      'Category': model.category,
    };
  }

  /// Get all products (with limit for performance)
  Future<List<ProductRecord>> getAllProducts({int limit = 20}) async {
    try {
      final snapshot = await collection
          .orderBy('Date', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => ProductRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  /// Get products by category with proper indexing
  Future<List<ProductRecord>> getProductsByCategory(
    String category, {
    int limit = 20,
  }) async {
    try {
      // Uses the composite index: Category (ASC) + Date (DESC)
      final snapshot = await collection
          .where('Category', isEqualTo: category)
          .orderBy('Date', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => ProductRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  /// Search products by name within a category
  Future<List<ProductRecord>> searchProductsByName(
    String category,
    String searchTerm, {
    int limit = 20,
  }) async {
    try {
      // Uses the composite index: Category (ASC) + Name (ASC)
      final snapshot = await collection
          .where('Category', isEqualTo: category)
          .where('Name', isGreaterThanOrEqualTo: searchTerm)
          .where('Name', isLessThan: searchTerm + 'z')
          .orderBy('Name')
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => ProductRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  /// Get products filtered by price range within a category
  Future<List<ProductRecord>> getProductsByPriceRange(
    String category, {
    double? minPrice,
    double? maxPrice,
    int limit = 20,
  }) async {
    try {
      Query query = collection.where('Category', isEqualTo: category);

      if (minPrice != null) {
        query = query.where('Price', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null) {
        query = query.where('Price', isLessThanOrEqualTo: maxPrice);
      }

      // Uses the composite index: Category (ASC) + Price (ASC)
      query = query.orderBy('Price').limit(limit);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => ProductRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error filtering products by price: $e');
      return [];
    }
  }

  /// Stream products by category for real-time updates
  Stream<List<ProductRecord>> watchProductsByCategory(String category) {
    return collection
        .where('Category', isEqualTo: category)
        .orderBy('Date', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductRecord.fromSnapshot(doc)).toList();
    });
  }

  /// Stream all products for real-time updates
  Stream<List<ProductRecord>> watchAllProducts() {
    return collection
        .orderBy('Date', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductRecord.fromSnapshot(doc)).toList();
    });
  }

  /// Create a new product (admin only - enforced by security rules)
  Future<DocumentReference> createProduct({
    required String name,
    required double price,
    required String image,
    required String description,
    required int quantity,
    required String category,
  }) async {
    final productData = FirestoreDataSchema.getProductSchema(
      name: name,
      price: price,
      image: image,
      description: description,
      quantity: quantity,
      category: category,
    );

    return await collection.add(productData);
  }

  /// Update product quantity (for inventory management)
  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    await collection.doc(productId).update({
      'Quantity': newQuantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update product price
  Future<void> updateProductPrice(String productId, double newPrice) async {
    await collection.doc(productId).update({
      'Price': newPrice,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get product categories (aggregated query)
  Future<List<String>> getProductCategories() async {
    try {
      // This would typically use an aggregate query or maintain a separate categories collection
      final snapshot = await collection.get();
      final categories = <String>{};
      
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final category = data['Category'] as String?;
        if (category != null && category.isNotEmpty) {
          categories.add(category);
        }
      }
      
      return categories.toList()..sort();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  /// Check product availability
  Future<bool> isProductAvailable(String productId, int requestedQuantity) async {
    try {
      final doc = await collection.doc(productId).get();
      if (doc.exists) {
        final product = ProductRecord.fromSnapshot(doc);
        return product.quantity >= requestedQuantity;
      }
      return false;
    } catch (e) {
      print('Error checking product availability: $e');
      return false;
    }
  }

  /// Reserve product quantity (atomic transaction)
  Future<bool> reserveProduct(String productId, int quantity) async {
    try {
      return await FirebaseFirestore.instance.runTransaction((transaction) async {
        final productDoc = collection.doc(productId);
        final snapshot = await transaction.get(productDoc);

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>? ?? {};
          final currentQuantity = data['Quantity'] as int? ?? 0;
          
          if (currentQuantity >= quantity) {
            transaction.update(productDoc, {
              'Quantity': currentQuantity - quantity,
              'updatedAt': FieldValue.serverTimestamp(),
            });
            return true;
          }
        }
        return false;
      });
    } catch (e) {
      print('Error reserving product: $e');
      return false;
    }
  }
}