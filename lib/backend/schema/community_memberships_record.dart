import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CommunityMembershipsRecord extends FirestoreRecord {
  CommunityMembershipsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "membershipId" field.
  String? _membershipId;
  String get membershipId => _membershipId ?? '';
  bool hasMembershipId() => _membershipId != null;

  // "userId" field.
  DocumentReference? _userId;
  DocumentReference? get userId => _userId;
  bool hasUserId() => _userId != null;

  // "communityId" field.
  DocumentReference? _communityId;
  DocumentReference? get communityId => _communityId;
  bool hasCommunityId() => _communityId != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  bool hasRole() => _role != null;

  // "joinedAt" field.
  DateTime? _joinedAt;
  DateTime? get joinedAt => _joinedAt;
  bool hasJoinedAt() => _joinedAt != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  bool hasBio() => _bio != null;

  // "Contact" field.
  String? _contact;
  String get contact => _contact ?? '';
  bool hasContact() => _contact != null;

  // "tel" field.
  int? _tel;
  int get tel => _tel ?? 0;
  bool hasTel() => _tel != null;

  // "img" field.
  String? _img;
  String get img => _img ?? '';
  bool hasImg() => _img != null;

  // "joineduser" field.
  List<DocumentReference>? _joineduser;
  List<DocumentReference> get joineduser => _joineduser ?? const [];
  bool hasJoineduser() => _joineduser != null;

  void _initializeFields() {
    _membershipId = snapshotData['membershipId'] as String?;
    _userId = snapshotData['userId'] as DocumentReference?;
    _communityId = snapshotData['communityId'] as DocumentReference?;
    _role = snapshotData['role'] as String?;
    _joinedAt = snapshotData['joinedAt'] as DateTime?;
    _status = snapshotData['status'] as String?;
    _name = snapshotData['name'] as String?;
    _bio = snapshotData['bio'] as String?;
    _contact = snapshotData['Contact'] as String?;
    _tel = castToType<int>(snapshotData['tel']);
    _img = snapshotData['img'] as String?;
    _joineduser = getDataList(snapshotData['joineduser']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('CommunityMemberships');

  static Stream<CommunityMembershipsRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => CommunityMembershipsRecord.fromSnapshot(s));

  static Future<CommunityMembershipsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => CommunityMembershipsRecord.fromSnapshot(s));

  static CommunityMembershipsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CommunityMembershipsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CommunityMembershipsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CommunityMembershipsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CommunityMembershipsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CommunityMembershipsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCommunityMembershipsRecordData({
  String? membershipId,
  DocumentReference? userId,
  DocumentReference? communityId,
  String? role,
  DateTime? joinedAt,
  String? status,
  String? name,
  String? bio,
  String? contact,
  int? tel,
  String? img,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'membershipId': membershipId,
      'userId': userId,
      'communityId': communityId,
      'role': role,
      'joinedAt': joinedAt,
      'status': status,
      'name': name,
      'bio': bio,
      'Contact': contact,
      'tel': tel,
      'img': img,
    }.withoutNulls,
  );

  return firestoreData;
}

class CommunityMembershipsRecordDocumentEquality
    implements Equality<CommunityMembershipsRecord> {
  const CommunityMembershipsRecordDocumentEquality();

  @override
  bool equals(CommunityMembershipsRecord? e1, CommunityMembershipsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.membershipId == e2?.membershipId &&
        e1?.userId == e2?.userId &&
        e1?.communityId == e2?.communityId &&
        e1?.role == e2?.role &&
        e1?.joinedAt == e2?.joinedAt &&
        e1?.status == e2?.status &&
        e1?.name == e2?.name &&
        e1?.bio == e2?.bio &&
        e1?.contact == e2?.contact &&
        e1?.tel == e2?.tel &&
        e1?.img == e2?.img &&
        listEquality.equals(e1?.joineduser, e2?.joineduser);
  }

  @override
  int hash(CommunityMembershipsRecord? e) => const ListEquality().hash([
        e?.membershipId,
        e?.userId,
        e?.communityId,
        e?.role,
        e?.joinedAt,
        e?.status,
        e?.name,
        e?.bio,
        e?.contact,
        e?.tel,
        e?.img,
        e?.joineduser
      ]);

  @override
  bool isValidKey(Object? o) => o is CommunityMembershipsRecord;
}
