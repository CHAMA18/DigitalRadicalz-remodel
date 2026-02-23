import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductidRecord extends FirestoreRecord {
  ProductidRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "productid" field.
  DocumentReference? _productid;
  DocumentReference? get productid => _productid;
  bool hasProductid() => _productid != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  // "Price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "userid" field.
  DocumentReference? _userid;
  DocumentReference? get userid => _userid;
  bool hasUserid() => _userid != null;

  void _initializeFields() {
    _productid = snapshotData['productid'] as DocumentReference?;
    _quantity = castToType<int>(snapshotData['quantity']);
    _price = castToType<double>(snapshotData['Price']);
    _userid = snapshotData['userid'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Productid');

  static Stream<ProductidRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProductidRecord.fromSnapshot(s));

  static Future<ProductidRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProductidRecord.fromSnapshot(s));

  static ProductidRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProductidRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProductidRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProductidRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProductidRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProductidRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProductidRecordData({
  DocumentReference? productid,
  int? quantity,
  double? price,
  DocumentReference? userid,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'productid': productid,
      'quantity': quantity,
      'Price': price,
      'userid': userid,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProductidRecordDocumentEquality implements Equality<ProductidRecord> {
  const ProductidRecordDocumentEquality();

  @override
  bool equals(ProductidRecord? e1, ProductidRecord? e2) {
    return e1?.productid == e2?.productid &&
        e1?.quantity == e2?.quantity &&
        e1?.price == e2?.price &&
        e1?.userid == e2?.userid;
  }

  @override
  int hash(ProductidRecord? e) =>
      const ListEquality().hash([e?.productid, e?.quantity, e?.price, e?.userid]);

  @override
  bool isValidKey(Object? o) => o is ProductidRecord;
}
