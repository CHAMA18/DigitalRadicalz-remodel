import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatscollectionRecord extends FirestoreRecord {
  ChatscollectionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "users" field.
  List<DocumentReference>? _users;
  List<DocumentReference> get users => _users ?? const [];
  bool hasUsers() => _users != null;

  // "CreatedUsers" field.
  DocumentReference? _createdUsers;
  DocumentReference? get createdUsers => _createdUsers;
  bool hasCreatedUsers() => _createdUsers != null;

  // "Lastmessage" field.
  String? _lastmessage;
  String get lastmessage => _lastmessage ?? '';
  bool hasLastmessage() => _lastmessage != null;

  // "LastMessage_Datetime" field.
  DateTime? _lastMessageDatetime;
  DateTime? get lastMessageDatetime => _lastMessageDatetime;
  bool hasLastMessageDatetime() => _lastMessageDatetime != null;

  // "CreatedDatetime" field.
  DateTime? _createdDatetime;
  DateTime? get createdDatetime => _createdDatetime;
  bool hasCreatedDatetime() => _createdDatetime != null;

  // "Unreadusers" field.
  List<DocumentReference>? _unreadusers;
  List<DocumentReference> get unreadusers => _unreadusers ?? const [];
  bool hasUnreadusers() => _unreadusers != null;

  void _initializeFields() {
    _users = getDataList(snapshotData['users']);
    _createdUsers = snapshotData['CreatedUsers'] as DocumentReference?;
    _lastmessage = snapshotData['Lastmessage'] as String?;
    _lastMessageDatetime = snapshotData['LastMessage_Datetime'] as DateTime?;
    _createdDatetime = snapshotData['CreatedDatetime'] as DateTime?;
    _unreadusers = getDataList(snapshotData['Unreadusers']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Chatscollection');

  static Stream<ChatscollectionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatscollectionRecord.fromSnapshot(s));

  static Future<ChatscollectionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatscollectionRecord.fromSnapshot(s));

  static ChatscollectionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatscollectionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatscollectionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatscollectionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatscollectionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatscollectionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatscollectionRecordData({
  DocumentReference? createdUsers,
  String? lastmessage,
  DateTime? lastMessageDatetime,
  DateTime? createdDatetime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'CreatedUsers': createdUsers,
      'Lastmessage': lastmessage,
      'LastMessage_Datetime': lastMessageDatetime,
      'CreatedDatetime': createdDatetime,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatscollectionRecordDocumentEquality
    implements Equality<ChatscollectionRecord> {
  const ChatscollectionRecordDocumentEquality();

  @override
  bool equals(ChatscollectionRecord? e1, ChatscollectionRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.users, e2?.users) &&
        e1?.createdUsers == e2?.createdUsers &&
        e1?.lastmessage == e2?.lastmessage &&
        e1?.lastMessageDatetime == e2?.lastMessageDatetime &&
        e1?.createdDatetime == e2?.createdDatetime &&
        listEquality.equals(e1?.unreadusers, e2?.unreadusers);
  }

  @override
  int hash(ChatscollectionRecord? e) => const ListEquality().hash([
        e?.users,
        e?.createdUsers,
        e?.lastmessage,
        e?.lastMessageDatetime,
        e?.createdDatetime,
        e?.unreadusers
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatscollectionRecord;
}
