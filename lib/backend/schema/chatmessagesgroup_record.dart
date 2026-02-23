import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatmessagesgroupRecord extends FirestoreRecord {
  ChatmessagesgroupRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "chatref" field.
  DocumentReference? _chatref;
  DocumentReference? get chatref => _chatref;
  bool hasChatref() => _chatref != null;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "datetime" field.
  DateTime? _datetime;
  DateTime? get datetime => _datetime;
  bool hasDatetime() => _datetime != null;

  // "createdby" field.
  DocumentReference? _createdby;
  DocumentReference? get createdby => _createdby;
  bool hasCreatedby() => _createdby != null;

  void _initializeFields() {
    _chatref = snapshotData['chatref'] as DocumentReference?;
    _message = snapshotData['message'] as String?;
    _datetime = snapshotData['datetime'] as DateTime?;
    _createdby = snapshotData['createdby'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('chatmessagesgroup');

  static Stream<ChatmessagesgroupRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatmessagesgroupRecord.fromSnapshot(s));

  static Future<ChatmessagesgroupRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => ChatmessagesgroupRecord.fromSnapshot(s));

  static ChatmessagesgroupRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatmessagesgroupRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatmessagesgroupRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatmessagesgroupRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatmessagesgroupRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatmessagesgroupRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatmessagesgroupRecordData({
  DocumentReference? chatref,
  String? message,
  DateTime? datetime,
  DocumentReference? createdby,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'chatref': chatref,
      'message': message,
      'datetime': datetime,
      'createdby': createdby,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatmessagesgroupRecordDocumentEquality
    implements Equality<ChatmessagesgroupRecord> {
  const ChatmessagesgroupRecordDocumentEquality();

  @override
  bool equals(ChatmessagesgroupRecord? e1, ChatmessagesgroupRecord? e2) {
    return e1?.chatref == e2?.chatref &&
        e1?.message == e2?.message &&
        e1?.datetime == e2?.datetime &&
        e1?.createdby == e2?.createdby;
  }

  @override
  int hash(ChatmessagesgroupRecord? e) => const ListEquality()
      .hash([e?.chatref, e?.message, e?.datetime, e?.createdby]);

  @override
  bool isValidKey(Object? o) => o is ChatmessagesgroupRecord;
}
