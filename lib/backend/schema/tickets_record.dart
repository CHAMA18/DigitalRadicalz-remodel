import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TicketsRecord extends FirestoreRecord {
  TicketsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "ticketId" field.
  String? _ticketId;
  String get ticketId => _ticketId ?? '';
  bool hasTicketId() => _ticketId != null;

  // "userId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "eventId" field.
  DocumentReference? _eventId;
  DocumentReference? get eventId => _eventId;
  bool hasEventId() => _eventId != null;

  // "ticketTypeId" field.
  DocumentReference? _ticketTypeId;
  DocumentReference? get ticketTypeId => _ticketTypeId;
  bool hasTicketTypeId() => _ticketTypeId != null;

  // "orderId" field.
  DocumentReference? _orderId;
  DocumentReference? get orderId => _orderId;
  bool hasOrderId() => _orderId != null;

  // "qrCode" field.
  String? _qrCode;
  String get qrCode => _qrCode ?? '';
  bool hasQrCode() => _qrCode != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "purchaseDate" field.
  DateTime? _purchaseDate;
  DateTime? get purchaseDate => _purchaseDate;
  bool hasPurchaseDate() => _purchaseDate != null;

  // "validUntil" field.
  DateTime? _validUntil;
  DateTime? get validUntil => _validUntil;
  bool hasValidUntil() => _validUntil != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _ticketId = snapshotData['ticketId'] as String?;
    _userId = snapshotData['userId'] as DocumentReference?;
    _eventId = snapshotData['eventId'] as DocumentReference?;
    _ticketTypeId = snapshotData['ticketTypeId'] as DocumentReference?;
    _orderId = snapshotData['orderId'] as DocumentReference?;
    _qrCode = snapshotData['qrCode'] as String?;
    _status = snapshotData['status'] as String?;
    _purchaseDate = snapshotData['purchaseDate'] as DateTime?;
    _validUntil = snapshotData['validUntil'] as DateTime?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Tickets');

  static Stream<TicketsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TicketsRecord.fromSnapshot(s));

  static Future<TicketsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TicketsRecord.fromSnapshot(s));

  static TicketsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TicketsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TicketsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TicketsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TicketsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TicketsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTicketsRecordData({
  String? ticketId,
  DocumentReference? userId,
  DocumentReference? eventId,
  DocumentReference? ticketTypeId,
  DocumentReference? orderId,
  String? qrCode,
  String? status,
  DateTime? purchaseDate,
  DateTime? validUntil,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'ticketId': ticketId,
      'userId': userId,
      'eventId': eventId,
      'ticketTypeId': ticketTypeId,
      'orderId': orderId,
      'qrCode': qrCode,
      'status': status,
      'purchaseDate': purchaseDate,
      'validUntil': validUntil,
      'createdAt': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class TicketsRecordDocumentEquality implements Equality<TicketsRecord> {
  const TicketsRecordDocumentEquality();

  @override
  bool equals(TicketsRecord? e1, TicketsRecord? e2) {
    return e1?.ticketId == e2?.ticketId &&
        e1?.userId == e2?.userId &&
        e1?.eventId == e2?.eventId &&
        e1?.ticketTypeId == e2?.ticketTypeId &&
        e1?.orderId == e2?.orderId &&
        e1?.qrCode == e2?.qrCode &&
        e1?.status == e2?.status &&
        e1?.purchaseDate == e2?.purchaseDate &&
        e1?.validUntil == e2?.validUntil &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(TicketsRecord? e) => const ListEquality().hash([
        e?.ticketId,
        e?.userId,
        e?.eventId,
        e?.ticketTypeId,
        e?.orderId,
        e?.qrCode,
        e?.status,
        e?.purchaseDate,
        e?.validUntil,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is TicketsRecord;
}
