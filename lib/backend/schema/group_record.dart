import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GroupRecord extends FirestoreRecord {
  GroupRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "GroupName" field.
  String? _groupName;
  String get groupName => _groupName ?? '';
  bool hasGroupName() => _groupName != null;

  // "Groupdescription" field.
  String? _groupdescription;
  String get groupdescription => _groupdescription ?? '';
  bool hasGroupdescription() => _groupdescription != null;

  // "Chatid" field.
  DocumentReference? _chatid;
  DocumentReference? get chatid => _chatid;
  bool hasChatid() => _chatid != null;

  // "userid" field.
  DocumentReference? _userid;
  DocumentReference? get userid => _userid;
  bool hasUserid() => _userid != null;

  // "isjoined" field.
  String? _isjoined;
  String get isjoined => _isjoined ?? '';
  bool hasIsjoined() => _isjoined != null;

  // "Groupimg" field.
  String? _groupimg;
  String get groupimg => _groupimg ?? '';
  bool hasGroupimg() => _groupimg != null;

  void _initializeFields() {
    _groupName = snapshotData['GroupName'] as String?;
    _groupdescription = snapshotData['Groupdescription'] as String?;
    _chatid = snapshotData['Chatid'] as DocumentReference?;
    _userid = snapshotData['userid'] as DocumentReference?;
    _isjoined = snapshotData['isjoined'] as String?;
    _groupimg = snapshotData['Groupimg'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Group');

  static Stream<GroupRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GroupRecord.fromSnapshot(s));

  static Future<GroupRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GroupRecord.fromSnapshot(s));

  static GroupRecord fromSnapshot(DocumentSnapshot snapshot) => GroupRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GroupRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GroupRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GroupRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GroupRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGroupRecordData({
  String? groupName,
  String? groupdescription,
  DocumentReference? chatid,
  DocumentReference? userid,
  String? isjoined,
  String? groupimg,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'GroupName': groupName,
      'Groupdescription': groupdescription,
      'Chatid': chatid,
      'userid': userid,
      'isjoined': isjoined,
      'Groupimg': groupimg,
    }.withoutNulls,
  );

  return firestoreData;
}

class GroupRecordDocumentEquality implements Equality<GroupRecord> {
  const GroupRecordDocumentEquality();

  @override
  bool equals(GroupRecord? e1, GroupRecord? e2) {
    return e1?.groupName == e2?.groupName &&
        e1?.groupdescription == e2?.groupdescription &&
        e1?.chatid == e2?.chatid &&
        e1?.userid == e2?.userid &&
        e1?.isjoined == e2?.isjoined &&
        e1?.groupimg == e2?.groupimg;
  }

  @override
  int hash(GroupRecord? e) => const ListEquality().hash([
        e?.groupName,
        e?.groupdescription,
        e?.chatid,
        e?.userid,
        e?.isjoined,
        e?.groupimg
      ]);

  @override
  bool isValidKey(Object? o) => o is GroupRecord;
}
