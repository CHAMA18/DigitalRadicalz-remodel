import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderItemsRecord extends FirestoreRecord {
  OrderItemsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "orderItemId" field.
  String? _orderItemId;
  String get orderItemId => _orderItemId ?? '';
  bool hasOrderItemId() => _orderItemId != null;

  // "orderId" field.
  DocumentReference? _orderId;
  DocumentReference? get orderId => _orderId;
  bool hasOrderId() => _orderId != null;

  // "ticketTypeId" field.
  DocumentReference? _ticketTypeId;
  DocumentReference? get ticketTypeId => _ticketTypeId;
  bool hasTicketTypeId() => _ticketTypeId != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  // "unitPrice" field.
  double? _unitPrice;
  double get unitPrice => _unitPrice ?? 0.0;
  bool hasUnitPrice() => _unitPrice != null;

  // "subtotal" field.
  double? _subtotal;
  double get subtotal => _subtotal ?? 0.0;
  bool hasSubtotal() => _subtotal != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _orderItemId = snapshotData['orderItemId'] as String?;
    _orderId = snapshotData['orderId'] as DocumentReference?;
    _ticketTypeId = snapshotData['ticketTypeId'] as DocumentReference?;
    _quantity = castToType<int>(snapshotData['quantity']);
    _unitPrice = castToType<double>(snapshotData['unitPrice']);
    _subtotal = castToType<double>(snapshotData['subtotal']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('order_items');

  static Stream<OrderItemsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrderItemsRecord.fromSnapshot(s));

  static Future<OrderItemsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrderItemsRecord.fromSnapshot(s));

  static OrderItemsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OrderItemsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrderItemsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrderItemsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrderItemsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrderItemsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrderItemsRecordData({
  String? orderItemId,
  DocumentReference? orderId,
  DocumentReference? ticketTypeId,
  int? quantity,
  double? unitPrice,
  double? subtotal,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'orderItemId': orderItemId,
      'orderId': orderId,
      'ticketTypeId': ticketTypeId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrderItemsRecordDocumentEquality implements Equality<OrderItemsRecord> {
  const OrderItemsRecordDocumentEquality();

  @override
  bool equals(OrderItemsRecord? e1, OrderItemsRecord? e2) {
    return e1?.orderItemId == e2?.orderItemId &&
        e1?.orderId == e2?.orderId &&
        e1?.ticketTypeId == e2?.ticketTypeId &&
        e1?.quantity == e2?.quantity &&
        e1?.unitPrice == e2?.unitPrice &&
        e1?.subtotal == e2?.subtotal &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(OrderItemsRecord? e) => const ListEquality().hash([
        e?.orderItemId,
        e?.orderId,
        e?.ticketTypeId,
        e?.quantity,
        e?.unitPrice,
        e?.subtotal,
        e?.createdAt,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is OrderItemsRecord;
}
