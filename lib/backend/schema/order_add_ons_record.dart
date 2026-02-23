import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderAddOnsRecord extends FirestoreRecord {
  OrderAddOnsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "addonId" field.
  String? _addonId;
  String get addonId => _addonId ?? '';
  bool hasAddonId() => _addonId != null;

  // "orderId" field.
  DocumentReference? _orderId;
  DocumentReference? get orderId => _orderId;
  bool hasOrderId() => _orderId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "selected" field.
  bool? _selected;
  bool get selected => _selected ?? false;
  bool hasSelected() => _selected != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _addonId = snapshotData['addonId'] as String?;
    _orderId = snapshotData['orderId'] as DocumentReference?;
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _selected = snapshotData['selected'] as bool?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('OrderAdd-ons');

  static Stream<OrderAddOnsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrderAddOnsRecord.fromSnapshot(s));

  static Future<OrderAddOnsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrderAddOnsRecord.fromSnapshot(s));

  static OrderAddOnsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrderAddOnsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrderAddOnsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrderAddOnsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrderAddOnsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrderAddOnsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrderAddOnsRecordData({
  String? addonId,
  DocumentReference? orderId,
  String? name,
  String? description,
  double? price,
  bool? selected,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'addonId': addonId,
      'orderId': orderId,
      'name': name,
      'description': description,
      'price': price,
      'selected': selected,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrderAddOnsRecordDocumentEquality implements Equality<OrderAddOnsRecord> {
  const OrderAddOnsRecordDocumentEquality();

  @override
  bool equals(OrderAddOnsRecord? e1, OrderAddOnsRecord? e2) {
    return e1?.addonId == e2?.addonId &&
        e1?.orderId == e2?.orderId &&
        e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.price == e2?.price &&
        e1?.selected == e2?.selected &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(OrderAddOnsRecord? e) => const ListEquality().hash([
        e?.addonId,
        e?.orderId,
        e?.name,
        e?.description,
        e?.price,
        e?.selected,
        e?.createdAt,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is OrderAddOnsRecord;
}
