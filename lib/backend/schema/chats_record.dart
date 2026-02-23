import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatsRecord extends FirestoreRecord {
  ChatsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Lastmessage" field.
  String? _lastmessage;
  String get lastmessage => _lastmessage ?? '';
  bool hasLastmessage() => _lastmessage != null;

  // "userid" field.
  List<DocumentReference>? _userid;
  List<DocumentReference> get userid => _userid ?? const [];
  bool hasUserid() => _userid != null;

  // "usernames" field.
  List<String>? _usernames;
  List<String> get usernames => _usernames ?? const [];
  bool hasUsernames() => _usernames != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "lastmessageseenby" field.
  List<DocumentReference>? _lastmessageseenby;
  List<DocumentReference> get lastmessageseenby =>
      _lastmessageseenby ?? const [];
  bool hasLastmessageseenby() => _lastmessageseenby != null;

  // "lastvoice" field.
  String? _lastvoice;
  String get lastvoice => _lastvoice ?? '';
  bool hasLastvoice() => _lastvoice != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  void _initializeFields() {
    _lastmessage = snapshotData['Lastmessage'] as String?;
    _userid = getDataList(snapshotData['userid']);
    _usernames = getDataList(snapshotData['usernames']);
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _lastmessageseenby = getDataList(snapshotData['lastmessageseenby']);
    _lastvoice = snapshotData['lastvoice'] as String?;
    _images = getDataList(snapshotData['images']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Chats');

  static Stream<ChatsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatsRecord.fromSnapshot(s));

  static Future<ChatsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatsRecord.fromSnapshot(s));

  static ChatsRecord fromSnapshot(DocumentSnapshot snapshot) => ChatsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatsRecordData({
  String? lastmessage,
  DateTime? timestamp,
  String? lastvoice,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Lastmessage': lastmessage,
      'timestamp': timestamp,
      'lastvoice': lastvoice,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatsRecordDocumentEquality implements Equality<ChatsRecord> {
  const ChatsRecordDocumentEquality();

  @override
  bool equals(ChatsRecord? e1, ChatsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.lastmessage == e2?.lastmessage &&
        listEquality.equals(e1?.userid, e2?.userid) &&
        listEquality.equals(e1?.usernames, e2?.usernames) &&
        e1?.timestamp == e2?.timestamp &&
        listEquality.equals(e1?.lastmessageseenby, e2?.lastmessageseenby) &&
        e1?.lastvoice == e2?.lastvoice &&
        listEquality.equals(e1?.images, e2?.images);
  }

  @override
  int hash(ChatsRecord? e) => const ListEquality().hash([
        e?.lastmessage,
        e?.userid,
        e?.usernames,
        e?.timestamp,
        e?.lastmessageseenby,
        e?.lastvoice,
        e?.images
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatsRecord;
}
