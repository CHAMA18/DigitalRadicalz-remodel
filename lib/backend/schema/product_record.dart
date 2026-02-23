import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductRecord extends FirestoreRecord {
  ProductRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "Price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "Image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "Description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "Quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  // "Date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "Category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "Discountprice" field.
  double? _discountprice;
  double get discountprice => _discountprice ?? 0.0;
  bool hasDiscountprice() => _discountprice != null;

  // "Sizecapacity" field.
  String? _sizecapacity;
  String get sizecapacity => _sizecapacity ?? '';
  bool hasSizecapacity() => _sizecapacity != null;

  void _initializeFields() {
    _name = snapshotData['Name'] as String?;
    _price = castToType<double>(snapshotData['Price']);
    _image = snapshotData['Image'] as String?;
    _description = snapshotData['Description'] as String?;
    _quantity = castToType<int>(snapshotData['Quantity']);
    _date = snapshotData['Date'] as DateTime?;
    _category = snapshotData['Category'] as String?;
    _discountprice = castToType<double>(snapshotData['Discountprice']);
    _sizecapacity = snapshotData['Sizecapacity'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Product');

  static Stream<ProductRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProductRecord.fromSnapshot(s));

  static Future<ProductRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProductRecord.fromSnapshot(s));

  static ProductRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProductRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProductRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProductRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProductRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProductRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProductRecordData({
  String? name,
  double? price,
  String? image,
  String? description,
  int? quantity,
  DateTime? date,
  String? category,
  double? discountprice,
  String? sizecapacity,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Name': name,
      'Price': price,
      'Image': image,
      'Description': description,
      'Quantity': quantity,
      'Date': date,
      'Category': category,
      'Discountprice': discountprice,
      'Sizecapacity': sizecapacity,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProductRecordDocumentEquality implements Equality<ProductRecord> {
  const ProductRecordDocumentEquality();

  @override
  bool equals(ProductRecord? e1, ProductRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.price == e2?.price &&
        e1?.image == e2?.image &&
        e1?.description == e2?.description &&
        e1?.quantity == e2?.quantity &&
        e1?.date == e2?.date &&
        e1?.category == e2?.category &&
        e1?.discountprice == e2?.discountprice &&
        e1?.sizecapacity == e2?.sizecapacity;
  }

  @override
  int hash(ProductRecord? e) => const ListEquality().hash([
        e?.name,
        e?.price,
        e?.image,
        e?.description,
        e?.quantity,
        e?.date,
        e?.category,
        e?.discountprice,
        e?.sizecapacity
      ]);

  @override
  bool isValidKey(Object? o) => o is ProductRecord;
}
