import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatmessagesRecord extends FirestoreRecord {
  ChatmessagesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  bool hasMessage() => _message != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "uidofsender" field.
  DocumentReference? _uidofsender;
  DocumentReference? get uidofsender => _uidofsender;
  bool hasUidofsender() => _uidofsender != null;

  // "nameofsender" field.
  String? _nameofsender;
  String get nameofsender => _nameofsender ?? '';
  bool hasNameofsender() => _nameofsender != null;

  // "voice" field.
  String? _voice;
  String get voice => _voice ?? '';
  bool hasVoice() => _voice != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _message = snapshotData['message'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _uidofsender = snapshotData['uidofsender'] as DocumentReference?;
    _nameofsender = snapshotData['nameofsender'] as String?;
    _voice = snapshotData['voice'] as String?;
    _images = getDataList(snapshotData['images']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('Chatmessages')
          : FirebaseFirestore.instance.collectionGroup('Chatmessages');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('Chatmessages').doc(id);

  static Stream<ChatmessagesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChatmessagesRecord.fromSnapshot(s));

  static Future<ChatmessagesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChatmessagesRecord.fromSnapshot(s));

  static ChatmessagesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChatmessagesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChatmessagesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChatmessagesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChatmessagesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChatmessagesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChatmessagesRecordData({
  String? message,
  DateTime? timestamp,
  DocumentReference? uidofsender,
  String? nameofsender,
  String? voice,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'message': message,
      'timestamp': timestamp,
      'uidofsender': uidofsender,
      'nameofsender': nameofsender,
      'voice': voice,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChatmessagesRecordDocumentEquality
    implements Equality<ChatmessagesRecord> {
  const ChatmessagesRecordDocumentEquality();

  @override
  bool equals(ChatmessagesRecord? e1, ChatmessagesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.message == e2?.message &&
        e1?.timestamp == e2?.timestamp &&
        e1?.uidofsender == e2?.uidofsender &&
        e1?.nameofsender == e2?.nameofsender &&
        e1?.voice == e2?.voice &&
        listEquality.equals(e1?.images, e2?.images);
  }

  @override
  int hash(ChatmessagesRecord? e) => const ListEquality().hash([
        e?.message,
        e?.timestamp,
        e?.uidofsender,
        e?.nameofsender,
        e?.voice,
        e?.images
      ]);

  @override
  bool isValidKey(Object? o) => o is ChatmessagesRecord;
}
