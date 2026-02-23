import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "orderId" field.
  String? _orderId;
  String get orderId => _orderId ?? '';
  bool hasOrderId() => _orderId != null;

  // "userId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "eventId" field.
  DocumentReference? _eventId;
  DocumentReference? get eventId => _eventId;
  bool hasEventId() => _eventId != null;

  // "customerEmail" field.
  String? _customerEmail;
  String get customerEmail => _customerEmail ?? '';
  bool hasCustomerEmail() => _customerEmail != null;

  // "customerName" field.
  String? _customerName;
  String get customerName => _customerName ?? '';
  bool hasCustomerName() => _customerName != null;

  // "subtotal" field.
  double? _subtotal;
  double get subtotal => _subtotal ?? 0.0;
  bool hasSubtotal() => _subtotal != null;

  // "fees" field.
  double? _fees;
  double get fees => _fees ?? 0.0;
  bool hasFees() => _fees != null;

  // "tax" field.
  double? _tax;
  double get tax => _tax ?? 0.0;
  bool hasTax() => _tax != null;

  // "total" field.
  double? _total;
  double get total => _total ?? 0.0;
  bool hasTotal() => _total != null;

  // "paymentMethod" field.
  String? _paymentMethod;
  String get paymentMethod => _paymentMethod ?? '';
  bool hasPaymentMethod() => _paymentMethod != null;

  // "paymentStatus" field.
  String? _paymentStatus;
  String get paymentStatus => _paymentStatus ?? '';
  bool hasPaymentStatus() => _paymentStatus != null;

  // "transactionId" field.
  String? _transactionId;
  String get transactionId => _transactionId ?? '';
  bool hasTransactionId() => _transactionId != null;

  // "paidAt" field.
  DateTime? _paidAt;
  DateTime? get paidAt => _paidAt;
  bool hasPaidAt() => _paidAt != null;

  // "deliveryMethod" field.
  String? _deliveryMethod;
  String get deliveryMethod => _deliveryMethod ?? '';
  bool hasDeliveryMethod() => _deliveryMethod != null;

  // "deliveredAt" field.
  DateTime? _deliveredAt;
  DateTime? get deliveredAt => _deliveredAt;
  bool hasDeliveredAt() => _deliveredAt != null;

  // "acceptedTerms" field.
  bool? _acceptedTerms;
  bool get acceptedTerms => _acceptedTerms ?? false;
  bool hasAcceptedTerms() => _acceptedTerms != null;

  // "promotionalEmails" field.
  bool? _promotionalEmails;
  bool get promotionalEmails => _promotionalEmails ?? false;
  bool hasPromotionalEmails() => _promotionalEmails != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "tickettyperef" field.
  DocumentReference? _tickettyperef;
  DocumentReference? get tickettyperef => _tickettyperef;
  bool hasTickettyperef() => _tickettyperef != null;

  void _initializeFields() {
    _orderId = snapshotData['orderId'] as String?;
    _userId = snapshotData['userId'] as DocumentReference?;
    _eventId = snapshotData['eventId'] as DocumentReference?;
    _customerEmail = snapshotData['customerEmail'] as String?;
    _customerName = snapshotData['customerName'] as String?;
    _subtotal = castToType<double>(snapshotData['subtotal']);
    _fees = castToType<double>(snapshotData['fees']);
    _tax = castToType<double>(snapshotData['tax']);
    _total = castToType<double>(snapshotData['total']);
    _paymentMethod = snapshotData['paymentMethod'] as String?;
    _paymentStatus = snapshotData['paymentStatus'] as String?;
    _transactionId = snapshotData['transactionId'] as String?;
    _paidAt = snapshotData['paidAt'] as DateTime?;
    _deliveryMethod = snapshotData['deliveryMethod'] as String?;
    _deliveredAt = snapshotData['deliveredAt'] as DateTime?;
    _acceptedTerms = snapshotData['acceptedTerms'] as bool?;
    _promotionalEmails = snapshotData['promotionalEmails'] as bool?;
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _tickettyperef = snapshotData['tickettyperef'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdersRecordData({
  String? orderId,
  DocumentReference? userId,
  DocumentReference? eventId,
  String? customerEmail,
  String? customerName,
  double? subtotal,
  double? fees,
  double? tax,
  double? total,
  String? paymentMethod,
  String? paymentStatus,
  String? transactionId,
  DateTime? paidAt,
  String? deliveryMethod,
  DateTime? deliveredAt,
  bool? acceptedTerms,
  bool? promotionalEmails,
  String? status,
  DateTime? createdAt,
  DateTime? updatedAt,
  DocumentReference? tickettyperef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'orderId': orderId,
      'userId': userId,
      'eventId': eventId,
      'customerEmail': customerEmail,
      'customerName': customerName,
      'subtotal': subtotal,
      'fees': fees,
      'tax': tax,
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'paidAt': paidAt,
      'deliveryMethod': deliveryMethod,
      'deliveredAt': deliveredAt,
      'acceptedTerms': acceptedTerms,
      'promotionalEmails': promotionalEmails,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tickettyperef': tickettyperef,
    }.withoutNulls,
  );

  return firestoreData;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    return e1?.orderId == e2?.orderId &&
        e1?.userId == e2?.userId &&
        e1?.eventId == e2?.eventId &&
        e1?.customerEmail == e2?.customerEmail &&
        e1?.customerName == e2?.customerName &&
        e1?.subtotal == e2?.subtotal &&
        e1?.fees == e2?.fees &&
        e1?.tax == e2?.tax &&
        e1?.total == e2?.total &&
        e1?.paymentMethod == e2?.paymentMethod &&
        e1?.paymentStatus == e2?.paymentStatus &&
        e1?.transactionId == e2?.transactionId &&
        e1?.paidAt == e2?.paidAt &&
        e1?.deliveryMethod == e2?.deliveryMethod &&
        e1?.deliveredAt == e2?.deliveredAt &&
        e1?.acceptedTerms == e2?.acceptedTerms &&
        e1?.promotionalEmails == e2?.promotionalEmails &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.tickettyperef == e2?.tickettyperef;
  }

  @override
  int hash(OrdersRecord? e) => const ListEquality().hash([
        e?.orderId,
        e?.userId,
        e?.eventId,
        e?.customerEmail,
        e?.customerName,
        e?.subtotal,
        e?.fees,
        e?.tax,
        e?.total,
        e?.paymentMethod,
        e?.paymentStatus,
        e?.transactionId,
        e?.paidAt,
        e?.deliveryMethod,
        e?.deliveredAt,
        e?.acceptedTerms,
        e?.promotionalEmails,
        e?.status,
        e?.createdAt,
        e?.updatedAt,
        e?.tickettyperef
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;
}
