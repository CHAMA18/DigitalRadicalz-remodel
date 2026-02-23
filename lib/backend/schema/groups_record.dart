import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GroupsRecord extends FirestoreRecord {
  GroupsRecord._(
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

  // "groupimage" field.
  String? _groupimage;
  String get groupimage => _groupimage ?? '';
  bool hasGroupimage() => _groupimage != null;

  // "GroupName" field.
  String? _groupName;
  String get groupName => _groupName ?? '';
  bool hasGroupName() => _groupName != null;

  // "GroupDescription" field.
  String? _groupDescription;
  String get groupDescription => _groupDescription ?? '';
  bool hasGroupDescription() => _groupDescription != null;

  // "adminId" field.
  DocumentReference? _adminId;
  DocumentReference? get adminId => _adminId;
  bool hasAdminId() => _adminId != null;

  // "adminIds" field - list of admin user references
  List<DocumentReference>? _adminIds;
  List<DocumentReference> get adminIds => _adminIds ?? const [];
  bool hasAdminIds() => _adminIds != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _lastmessage = snapshotData['Lastmessage'] as String?;
    _userid = getDataList(snapshotData['userid']);
    _usernames = getDataList(snapshotData['usernames']);
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _lastmessageseenby = getDataList(snapshotData['lastmessageseenby']);
    _lastvoice = snapshotData['lastvoice'] as String?;
    _images = getDataList(snapshotData['images']);
    _groupimage = snapshotData['groupimage'] as String?;
    _groupName = snapshotData['GroupName'] as String?;
    _groupDescription = snapshotData['GroupDescription'] as String?;
    _adminId = snapshotData['adminId'] as DocumentReference?;
    _adminIds = getDataList(snapshotData['adminIds']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Groups');

  static Stream<GroupsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GroupsRecord.fromSnapshot(s));

  static Future<GroupsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GroupsRecord.fromSnapshot(s));

  static GroupsRecord fromSnapshot(DocumentSnapshot snapshot) => GroupsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GroupsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GroupsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GroupsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GroupsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGroupsRecordData({
  String? lastmessage,
  DateTime? timestamp,
  String? lastvoice,
  String? groupimage,
  String? groupName,
  String? groupDescription,
  DocumentReference? adminId,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Lastmessage': lastmessage,
      'timestamp': timestamp,
      'lastvoice': lastvoice,
      'groupimage': groupimage,
      'GroupName': groupName,
      'GroupDescription': groupDescription,
      'adminId': adminId,
      'createdAt': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class GroupsRecordDocumentEquality implements Equality<GroupsRecord> {
  const GroupsRecordDocumentEquality();

  @override
  bool equals(GroupsRecord? e1, GroupsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.lastmessage == e2?.lastmessage &&
        listEquality.equals(e1?.userid, e2?.userid) &&
        listEquality.equals(e1?.usernames, e2?.usernames) &&
        e1?.timestamp == e2?.timestamp &&
        listEquality.equals(e1?.lastmessageseenby, e2?.lastmessageseenby) &&
        e1?.lastvoice == e2?.lastvoice &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.groupimage == e2?.groupimage &&
        e1?.groupName == e2?.groupName &&
        e1?.groupDescription == e2?.groupDescription &&
        e1?.adminId == e2?.adminId &&
        listEquality.equals(e1?.adminIds, e2?.adminIds) &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(GroupsRecord? e) => const ListEquality().hash([
        e?.lastmessage,
        e?.userid,
        e?.usernames,
        e?.timestamp,
        e?.lastmessageseenby,
        e?.lastvoice,
        e?.images,
        e?.groupimage,
        e?.groupName,
        e?.groupDescription,
        e?.adminId,
        e?.adminIds,
        e?.createdAt
      ]);

  @override
  bool isValidKey(Object? o) => o is GroupsRecord;
}
