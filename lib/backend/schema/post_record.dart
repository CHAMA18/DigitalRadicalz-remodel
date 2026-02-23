import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PostRecord extends FirestoreRecord {
  PostRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "postid" field.
  String? _postid;
  String get postid => _postid ?? '';
  bool hasPostid() => _postid != null;

  // "communityid" field.
  DocumentReference? _communityid;
  DocumentReference? get communityid => _communityid;
  bool hasCommunityid() => _communityid != null;

  // "comumunityname" field.
  String? _comumunityname;
  String get comumunityname => _comumunityname ?? '';
  bool hasComumunityname() => _comumunityname != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "members" field.
  List<DocumentReference>? _members;
  List<DocumentReference> get members => _members ?? const [];
  bool hasMembers() => _members != null;

  // "commentcount" field.
  double? _commentcount;
  double get commentcount => _commentcount ?? 0.0;
  bool hasCommentcount() => _commentcount != null;

  // "dateofapload" field.
  DateTime? _dateofapload;
  DateTime? get dateofapload => _dateofapload;
  bool hasDateofapload() => _dateofapload != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "Posted_likeby" field.
  List<DocumentReference>? _postedLikeby;
  List<DocumentReference> get postedLikeby => _postedLikeby ?? const [];
  bool hasPostedLikeby() => _postedLikeby != null;

  // "postedby" field.
  DocumentReference? _postedby;
  DocumentReference? get postedby => _postedby;
  bool hasPostedby() => _postedby != null;

  void _initializeFields() {
    _postid = snapshotData['postid'] as String?;
    _communityid = snapshotData['communityid'] as DocumentReference?;
    _comumunityname = snapshotData['comumunityname'] as String?;
    _image = snapshotData['image'] as String?;
    _members = getDataList(snapshotData['members']);
    _commentcount = castToType<double>(snapshotData['commentcount']);
    _dateofapload = snapshotData['dateofapload'] as DateTime?;
    _description = snapshotData['description'] as String?;
    _postedLikeby = getDataList(snapshotData['Posted_likeby']);
    _postedby = snapshotData['postedby'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Post');

  static Stream<PostRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PostRecord.fromSnapshot(s));

  static Future<PostRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PostRecord.fromSnapshot(s));

  static PostRecord fromSnapshot(DocumentSnapshot snapshot) => PostRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PostRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PostRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PostRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PostRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPostRecordData({
  String? postid,
  DocumentReference? communityid,
  String? comumunityname,
  String? image,
  double? commentcount,
  DateTime? dateofapload,
  String? description,
  DocumentReference? postedby,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'postid': postid,
      'communityid': communityid,
      'comumunityname': comumunityname,
      'image': image,
      'commentcount': commentcount,
      'dateofapload': dateofapload,
      'description': description,
      'postedby': postedby,
    }.withoutNulls,
  );

  return firestoreData;
}

class PostRecordDocumentEquality implements Equality<PostRecord> {
  const PostRecordDocumentEquality();

  @override
  bool equals(PostRecord? e1, PostRecord? e2) {
    const listEquality = ListEquality();
    return e1?.postid == e2?.postid &&
        e1?.communityid == e2?.communityid &&
        e1?.comumunityname == e2?.comumunityname &&
        e1?.image == e2?.image &&
        listEquality.equals(e1?.members, e2?.members) &&
        e1?.commentcount == e2?.commentcount &&
        e1?.dateofapload == e2?.dateofapload &&
        e1?.description == e2?.description &&
        listEquality.equals(e1?.postedLikeby, e2?.postedLikeby) &&
        e1?.postedby == e2?.postedby;
  }

  @override
  int hash(PostRecord? e) => const ListEquality().hash([
        e?.postid,
        e?.communityid,
        e?.comumunityname,
        e?.image,
        e?.members,
        e?.commentcount,
        e?.dateofapload,
        e?.description,
        e?.postedLikeby,
        e?.postedby
      ]);

  @override
  bool isValidKey(Object? o) => o is PostRecord;
}
