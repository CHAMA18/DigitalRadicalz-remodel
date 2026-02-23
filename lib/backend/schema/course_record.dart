import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CourseRecord extends FirestoreRecord {
  CourseRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "coursename" field.
  String? _coursename;
  String get coursename => _coursename ?? '';
  bool hasCoursename() => _coursename != null;

  // "Coursedescription" field.
  String? _coursedescription;
  String get coursedescription => _coursedescription ?? '';
  bool hasCoursedescription() => _coursedescription != null;

  // "Coursetype" field.
  String? _coursetype;
  String get coursetype => _coursetype ?? '';
  bool hasCoursetype() => _coursetype != null;

  // "instructorname" field.
  String? _instructorname;
  String get instructorname => _instructorname ?? '';
  bool hasInstructorname() => _instructorname != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "duration" field.
  String? _duration;
  String get duration => _duration ?? '';
  bool hasDuration() => _duration != null;

  // "publishedat" field.
  DateTime? _publishedat;
  DateTime? get publishedat => _publishedat;
  bool hasPublishedat() => _publishedat != null;

  // "ownerid" field.
  DocumentReference? _ownerid;
  DocumentReference? get ownerid => _ownerid;
  bool hasOwnerid() => _ownerid != null;

  // "joineduser" field.
  List<DocumentReference>? _joineduser;
  List<DocumentReference> get joineduser => _joineduser ?? const [];
  bool hasJoineduser() => _joineduser != null;

  void _initializeFields() {
    _coursename = snapshotData['coursename'] as String?;
    _coursedescription = snapshotData['Coursedescription'] as String?;
    _coursetype = snapshotData['Coursetype'] as String?;
    _instructorname = snapshotData['instructorname'] as String?;
    _image = snapshotData['image'] as String?;
    _duration = snapshotData['duration'] as String?;
    _publishedat = snapshotData['publishedat'] as DateTime?;
    _ownerid = snapshotData['ownerid'] as DocumentReference?;
    _joineduser = getDataList(snapshotData['joineduser']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Course');

  static Stream<CourseRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CourseRecord.fromSnapshot(s));

  static Future<CourseRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CourseRecord.fromSnapshot(s));

  static CourseRecord fromSnapshot(DocumentSnapshot snapshot) => CourseRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CourseRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CourseRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CourseRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CourseRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCourseRecordData({
  String? coursename,
  String? coursedescription,
  String? coursetype,
  String? instructorname,
  String? image,
  String? duration,
  DateTime? publishedat,
  DocumentReference? ownerid,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'coursename': coursename,
      'Coursedescription': coursedescription,
      'Coursetype': coursetype,
      'instructorname': instructorname,
      'image': image,
      'duration': duration,
      'publishedat': publishedat,
      'ownerid': ownerid,
    }.withoutNulls,
  );

  return firestoreData;
}

class CourseRecordDocumentEquality implements Equality<CourseRecord> {
  const CourseRecordDocumentEquality();

  @override
  bool equals(CourseRecord? e1, CourseRecord? e2) {
    const listEquality = ListEquality();
    return e1?.coursename == e2?.coursename &&
        e1?.coursedescription == e2?.coursedescription &&
        e1?.coursetype == e2?.coursetype &&
        e1?.instructorname == e2?.instructorname &&
        e1?.image == e2?.image &&
        e1?.duration == e2?.duration &&
        e1?.publishedat == e2?.publishedat &&
        e1?.ownerid == e2?.ownerid &&
        listEquality.equals(e1?.joineduser, e2?.joineduser);
  }

  @override
  int hash(CourseRecord? e) => const ListEquality().hash([
        e?.coursename,
        e?.coursedescription,
        e?.coursetype,
        e?.instructorname,
        e?.image,
        e?.duration,
        e?.publishedat,
        e?.ownerid,
        e?.joineduser
      ]);

  @override
  bool isValidKey(Object? o) => o is CourseRecord;
}
