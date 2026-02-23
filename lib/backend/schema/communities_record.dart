import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunitiesRecord extends FirestoreRecord {
  CommunitiesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "communityid" field.
  String? _communityid;
  String get communityid => _communityid ?? '';
  bool hasCommunityid() => _communityid != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "membercount" field.
  int? _membercount;
  int get membercount => _membercount ?? 0;
  bool hasMembercount() => _membercount != null;

  // "ispublic" field.
  bool? _ispublic;
  bool get ispublic => _ispublic ?? false;
  bool hasIspublic() => _ispublic != null;

  // "createdbyid" field.
  DocumentReference? _createdbyid;
  DocumentReference? get createdbyid => _createdbyid;
  bool hasCreatedbyid() => _createdbyid != null;

  // "createdat" field.
  DateTime? _createdat;
  DateTime? get createdat => _createdat;
  bool hasCreatedat() => _createdat != null;

  // "updatedat" field.
  DateTime? _updatedat;
  DateTime? get updatedat => _updatedat;
  bool hasUpdatedat() => _updatedat != null;

  // "isjoined" field.
  bool? _isjoined;
  bool get isjoined => _isjoined ?? false;
  bool hasIsjoined() => _isjoined != null;

  // "joinedby" field.
  List<DocumentReference>? _joinedby;
  List<DocumentReference> get joinedby => _joinedby ?? const [];
  bool hasJoinedby() => _joinedby != null;

  // "subcategory" field.
  String? _subcategory;
  String get subcategory => _subcategory ?? '';
  bool hasSubcategory() => _subcategory != null;

  // "interested" field.
  bool? _interested;
  bool get interested => _interested ?? false;
  bool hasInterested() => _interested != null;

  void _initializeFields() {
    _communityid = snapshotData['communityid'] as String?;
    _name = snapshotData['name'] as String?;
    _description = snapshotData['description'] as String?;
    _image = snapshotData['image'] as String?;
    _category = snapshotData['category'] as String?;
    _membercount = castToType<int>(snapshotData['membercount']);
    _ispublic = snapshotData['ispublic'] as bool?;
    _createdbyid = snapshotData['createdbyid'] as DocumentReference?;
    _createdat = snapshotData['createdat'] as DateTime?;
    _updatedat = snapshotData['updatedat'] as DateTime?;
    _isjoined = snapshotData['isjoined'] as bool?;
    _joinedby = getDataList(snapshotData['joinedby']);
    _subcategory = snapshotData['subcategory'] as String?;
    _interested = snapshotData['interested'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('communities');

  static Stream<CommunitiesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CommunitiesRecord.fromSnapshot(s));

  static Future<CommunitiesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CommunitiesRecord.fromSnapshot(s));

  static CommunitiesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CommunitiesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CommunitiesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CommunitiesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CommunitiesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CommunitiesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCommunitiesRecordData({
  String? communityid,
  String? name,
  String? description,
  String? image,
  String? category,
  int? membercount,
  bool? ispublic,
  DocumentReference? createdbyid,
  DateTime? createdat,
  DateTime? updatedat,
  bool? isjoined,
  String? subcategory,
  bool? interested,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'communityid': communityid,
      'name': name,
      'description': description,
      'image': image,
      'category': category,
      'membercount': membercount,
      'ispublic': ispublic,
      'createdbyid': createdbyid,
      'createdat': createdat,
      'updatedat': updatedat,
      'isjoined': isjoined,
      'subcategory': subcategory,
      'interested': interested,
    }.withoutNulls,
  );

  return firestoreData;
}

class CommunitiesRecordDocumentEquality implements Equality<CommunitiesRecord> {
  const CommunitiesRecordDocumentEquality();

  @override
  bool equals(CommunitiesRecord? e1, CommunitiesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.communityid == e2?.communityid &&
        e1?.name == e2?.name &&
        e1?.description == e2?.description &&
        e1?.image == e2?.image &&
        e1?.category == e2?.category &&
        e1?.membercount == e2?.membercount &&
        e1?.ispublic == e2?.ispublic &&
        e1?.createdbyid == e2?.createdbyid &&
        e1?.createdat == e2?.createdat &&
        e1?.updatedat == e2?.updatedat &&
        e1?.isjoined == e2?.isjoined &&
        listEquality.equals(e1?.joinedby, e2?.joinedby) &&
        e1?.subcategory == e2?.subcategory &&
        e1?.interested == e2?.interested;
  }

  @override
  int hash(CommunitiesRecord? e) => const ListEquality().hash([
        e?.communityid,
        e?.name,
        e?.description,
        e?.image,
        e?.category,
        e?.membercount,
        e?.ispublic,
        e?.createdbyid,
        e?.createdat,
        e?.updatedat,
        e?.isjoined,
        e?.joinedby,
        e?.subcategory,
        e?.interested
      ]);

  @override
  bool isValidKey(Object? o) => o is CommunitiesRecord;
}
