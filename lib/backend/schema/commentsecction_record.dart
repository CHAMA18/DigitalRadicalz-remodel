import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommentsecctionRecord extends FirestoreRecord {
  CommentsecctionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Postid" field.
  DocumentReference? _postid;
  DocumentReference? get postid => _postid;
  bool hasPostid() => _postid != null;

  // "userid" field.
  DocumentReference? _userid;
  DocumentReference? get userid => _userid;
  bool hasUserid() => _userid != null;

  // "Comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  void _initializeFields() {
    _postid = snapshotData['Postid'] as DocumentReference?;
    _userid = snapshotData['userid'] as DocumentReference?;
    _comment = snapshotData['Comment'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Commentsecction');

  static Stream<CommentsecctionRecord> getDocument(DocumentReference ref) =>
    ref.snapshots().map((s) => CommentsecctionRecord.fromSnapshot(s));

  static Future<CommentsecctionRecord> getDocumentOnce(DocumentReference ref) =>
    ref.get().then((s) => CommentsecctionRecord.fromSnapshot(s));

  static CommentsecctionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CommentsecctionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CommentsecctionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CommentsecctionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CommentsecctionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CommentsecctionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCommentsecctionRecordData({
  DocumentReference? postid,
  DocumentReference? userid,
  String? comment,
  DateTime? timestamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Postid': postid,
      'userid': userid,
      'Comment': comment,
      'timestamp': timestamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class CommentsecctionRecordDocumentEquality
    implements Equality<CommentsecctionRecord> {
  const CommentsecctionRecordDocumentEquality();

  @override
  bool equals(CommentsecctionRecord? e1, CommentsecctionRecord? e2) {
    return e1?.postid == e2?.postid &&
        e1?.userid == e2?.userid &&
        e1?.comment == e2?.comment &&
        e1?.timestamp == e2?.timestamp;
  }

  @override
  int hash(CommentsecctionRecord? e) => const ListEquality()
      .hash([e?.postid, e?.userid, e?.comment, e?.timestamp]);

  @override
  bool isValidKey(Object? o) => o is CommentsecctionRecord;
}
