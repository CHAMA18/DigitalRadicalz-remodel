import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class Chats2Record extends FirestoreRecord {
  Chats2Record._(
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
          ? parent.collection('Chats2')
          : FirebaseFirestore.instance.collectionGroup('Chats2');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('Chats2').doc(id);

  static Stream<Chats2Record> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => Chats2Record.fromSnapshot(s));

  static Future<Chats2Record> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => Chats2Record.fromSnapshot(s));

  static Chats2Record fromSnapshot(DocumentSnapshot snapshot) => Chats2Record._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static Chats2Record getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      Chats2Record._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'Chats2Record(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is Chats2Record &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChats2RecordData({
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

class Chats2RecordDocumentEquality implements Equality<Chats2Record> {
  const Chats2RecordDocumentEquality();

  @override
  bool equals(Chats2Record? e1, Chats2Record? e2) {
    const listEquality = ListEquality();
    return e1?.message == e2?.message &&
        e1?.timestamp == e2?.timestamp &&
        e1?.uidofsender == e2?.uidofsender &&
        e1?.nameofsender == e2?.nameofsender &&
        e1?.voice == e2?.voice &&
        listEquality.equals(e1?.images, e2?.images);
  }

  @override
  int hash(Chats2Record? e) => const ListEquality().hash([
        e?.message,
        e?.timestamp,
        e?.uidofsender,
        e?.nameofsender,
        e?.voice,
        e?.images
      ]);

  @override
  bool isValidKey(Object? o) => o is Chats2Record;
}
