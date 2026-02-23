import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TicketTypesRecord extends FirestoreRecord {
  TicketTypesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "ticketTypeId" field.
  String? _ticketTypeId;
  String get ticketTypeId => _ticketTypeId ?? '';
  bool hasTicketTypeId() => _ticketTypeId != null;

  // "eventId" field.
  DocumentReference? _eventId;
  DocumentReference? get eventId => _eventId;
  bool hasEventId() => _eventId != null;

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

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  bool hasQuantity() => _quantity != null;

  // "quantityRemaining" field.
  int? _quantityRemaining;
  int get quantityRemaining => _quantityRemaining ?? 0;
  bool hasQuantityRemaining() => _quantityRemaining != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "TotalPrice" field.
  double? _totalPrice;
  double get totalPrice => _totalPrice ?? 0.0;
  bool hasTotalPrice() => _totalPrice != null;

  // "Fee" field.
  double? _fee;
  double get fee => _fee ?? 0.0;
  bool hasFee() => _fee != null;

  // "feename" field.
  String? _feename;
  String get feename => _feename ?? '';
  bool hasFeename() => _feename != null;

  void _initializeFields() {
    _ticketTypeId = snapshotData['ticketTypeId'] as String?;
    _eventId = snapshotData['eventId'] as DocumentReference?;
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _price = castToType<double>(snapshotData['price']);
    _quantity = castToType<int>(snapshotData['quantity']);
    _quantityRemaining = castToType<int>(snapshotData['quantityRemaining']);
    _isActive = snapshotData['isActive'] as bool?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _totalPrice = castToType<double>(snapshotData['TotalPrice']);
    _fee = castToType<double>(snapshotData['Fee']);
    _feename = snapshotData['feename'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('ticket_types');

  static Stream<TicketTypesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TicketTypesRecord.fromSnapshot(s));

  static Future<TicketTypesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TicketTypesRecord.fromSnapshot(s));

  static TicketTypesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TicketTypesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TicketTypesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TicketTypesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TicketTypesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TicketTypesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTicketTypesRecordData({
  String? ticketTypeId,
  DocumentReference? eventId,
  String? name,
  String? description,
  double? price,
  int? quantity,
  int? quantityRemaining,
  bool? isActive,
  DateTime? createdAt,
  DateTime? updatedAt,
  double? totalPrice,
  double? fee,
  String? feename,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'ticketTypeId': ticketTypeId,
      'eventId': eventId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'quantityRemaining': quantityRemaining,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'TotalPrice': totalPrice,
      'Fee': fee,
      'feename': feename,
    }.withoutNulls,
  );

  return firestoreData;
}

class TicketTypesRecordDocumentEquality implements Equality<TicketTypesRecord> {
  const TicketTypesRecordDocumentEquality();

  @override
  bool equals(TicketTypesRecord? e1, TicketTypesRecord? e2) {
    return e1?.ticketTypeId == e2?.ticketTypeId &&
        e1?.eventId == e2?.eventId &&
        e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.price == e2?.price &&
        e1?.quantity == e2?.quantity &&
        e1?.quantityRemaining == e2?.quantityRemaining &&
        e1?.isActive == e2?.isActive &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.totalPrice == e2?.totalPrice &&
        e1?.fee == e2?.fee &&
        e1?.feename == e2?.feename;
  }

  @override
  int hash(TicketTypesRecord? e) => const ListEquality().hash([
        e?.ticketTypeId,
        e?.eventId,
        e?.name,
        e?.description,
        e?.price,
        e?.quantity,
        e?.quantityRemaining,
        e?.isActive,
        e?.createdAt,
        e?.updatedAt,
        e?.totalPrice,
        e?.fee,
        e?.feename
      ]);

  @override
  bool isValidKey(Object? o) => o is TicketTypesRecord;
}
