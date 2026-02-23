import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Orders2Record extends FirestoreRecord {
  Orders2Record._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userid" field.
  DocumentReference? _userid;
  DocumentReference? get userid => _userid;
  bool hasUserid() => _userid != null;

  // "listofcarts" field.
  List<DocumentReference>? _listofcarts;
  List<DocumentReference> get listofcarts => _listofcarts ?? const [];
  bool hasListofcarts() => _listofcarts != null;

  void _initializeFields() {
    _userid = snapshotData['userid'] as DocumentReference?;
    _listofcarts = getDataList(snapshotData['listofcarts']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Orders2');

  static Stream<Orders2Record> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => Orders2Record.fromSnapshot(s));

  static Future<Orders2Record> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => Orders2Record.fromSnapshot(s));

  static Orders2Record fromSnapshot(DocumentSnapshot snapshot) =>
      Orders2Record._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Orders2Record getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      Orders2Record._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'Orders2Record(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is Orders2Record &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrders2RecordData({
  DocumentReference? userid,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userid': userid,
    }.withoutNulls,
  );

  return firestoreData;
}

class Orders2RecordDocumentEquality implements Equality<Orders2Record> {
  const Orders2RecordDocumentEquality();

  @override
  bool equals(Orders2Record? e1, Orders2Record? e2) {
    const listEquality = ListEquality();
    return e1?.userid == e2?.userid &&
        listEquality.equals(e1?.listofcarts, e2?.listofcarts);
  }

  @override
  int hash(Orders2Record? e) =>
      const ListEquality().hash([e?.userid, e?.listofcarts]);

  @override
  bool isValidKey(Object? o) => o is Orders2Record;
}
