import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CoursemodulesRecord extends FirestoreRecord {
  CoursemodulesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "moduleName" field.
  String? _moduleName;
  String get moduleName => _moduleName ?? '';
  bool hasModuleName() => _moduleName != null;

  // "ModuleDescription" field.
  String? _moduleDescription;
  String get moduleDescription => _moduleDescription ?? '';
  bool hasModuleDescription() => _moduleDescription != null;

  // "ModuleVideo" field.
  String? _moduleVideo;
  String get moduleVideo => _moduleVideo ?? '';
  bool hasModuleVideo() => _moduleVideo != null;

  // "Moduleimage" field.
  String? _moduleimage;
  String get moduleimage => _moduleimage ?? '';
  bool hasModuleimage() => _moduleimage != null;

  // "CourseId" field.
  DocumentReference? _courseId;
  DocumentReference? get courseId => _courseId;
  bool hasCourseId() => _courseId != null;

  // "time" field.
  String? _time;
  String get time => _time ?? '';
  bool hasTime() => _time != null;

  void _initializeFields() {
    _moduleName = snapshotData['moduleName'] as String?;
    _moduleDescription = snapshotData['ModuleDescription'] as String?;
    _moduleVideo = snapshotData['ModuleVideo'] as String?;
    _moduleimage = snapshotData['Moduleimage'] as String?;
    _courseId = snapshotData['CourseId'] as DocumentReference?;
    _time = snapshotData['time'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Coursemodules');

  static Stream<CoursemodulesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CoursemodulesRecord.fromSnapshot(s));

  static Future<CoursemodulesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CoursemodulesRecord.fromSnapshot(s));

  static CoursemodulesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      CoursemodulesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CoursemodulesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CoursemodulesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CoursemodulesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CoursemodulesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCoursemodulesRecordData({
  String? moduleName,
  String? moduleDescription,
  String? moduleVideo,
  String? moduleimage,
  DocumentReference? courseId,
  String? time,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'moduleName': moduleName,
      'ModuleDescription': moduleDescription,
      'ModuleVideo': moduleVideo,
      'Moduleimage': moduleimage,
      'CourseId': courseId,
      'time': time,
    }.withoutNulls,
  );

  return firestoreData;
}

class CoursemodulesRecordDocumentEquality
    implements Equality<CoursemodulesRecord> {
  const CoursemodulesRecordDocumentEquality();

  @override
  bool equals(CoursemodulesRecord? e1, CoursemodulesRecord? e2) {
    return e1?.moduleName == e2?.moduleName &&
        e1?.moduleDescription == e2?.moduleDescription &&
        e1?.moduleVideo == e2?.moduleVideo &&
        e1?.moduleimage == e2?.moduleimage &&
        e1?.courseId == e2?.courseId &&
        e1?.time == e2?.time;
  }

  @override
  int hash(CoursemodulesRecord? e) => const ListEquality().hash([
        e?.moduleName,
        e?.moduleDescription,
        e?.moduleVideo,
        e?.moduleimage,
        e?.courseId,
        e?.time
      ]);

  @override
  bool isValidKey(Object? o) => o is CoursemodulesRecord;
}
