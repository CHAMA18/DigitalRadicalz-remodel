import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AppPreferenceRecord extends FirestoreRecord {
  AppPreferenceRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "Feed" field.
  String? _feed;
  String get feed => _feed ?? '';
  bool hasFeed() => _feed != null;

  // "LatestNews" field.
  String? _latestNews;
  String get latestNews => _latestNews ?? '';
  bool hasLatestNews() => _latestNews != null;

  // "seeAll" field.
  String? _seeAll;
  String get seeAll => _seeAll ?? '';
  bool hasSeeAll() => _seeAll != null;

  // "Recommendedcommunities" field.
  String? _recommendedcommunities;
  String get recommendedcommunities => _recommendedcommunities ?? '';
  bool hasRecommendedcommunities() => _recommendedcommunities != null;

  // "Mijncommunities" field.
  String? _mijncommunities;
  String get mijncommunities => _mijncommunities ?? '';
  bool hasMijncommunities() => _mijncommunities != null;

  // "Agenda" field.
  String? _agenda;
  String get agenda => _agenda ?? '';
  bool hasAgenda() => _agenda != null;

  // "Agendadetails" field.
  String? _agendadetails;
  String get agendadetails => _agendadetails ?? '';
  bool hasAgendadetails() => _agendadetails != null;

  // "Berichten" field.
  String? _berichten;
  String get berichten => _berichten ?? '';
  bool hasBerichten() => _berichten != null;

  // "Boardleden" field.
  String? _boardleden;
  String get boardleden => _boardleden ?? '';
  bool hasBoardleden() => _boardleden != null;

  void _initializeFields() {
    _feed = snapshotData['Feed'] as String?;
    _latestNews = snapshotData['LatestNews'] as String?;
    _seeAll = snapshotData['seeAll'] as String?;
    _recommendedcommunities = snapshotData['Recommendedcommunities'] as String?;
    _mijncommunities = snapshotData['Mijncommunities'] as String?;
    _agenda = snapshotData['Agenda'] as String?;
    _agendadetails = snapshotData['Agendadetails'] as String?;
    _berichten = snapshotData['Berichten'] as String?;
    _boardleden = snapshotData['Boardleden'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('AppPreference');

  static Stream<AppPreferenceRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AppPreferenceRecord.fromSnapshot(s));

  static Future<AppPreferenceRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AppPreferenceRecord.fromSnapshot(s));

  static AppPreferenceRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AppPreferenceRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AppPreferenceRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AppPreferenceRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AppPreferenceRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AppPreferenceRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAppPreferenceRecordData({
  String? feed,
  String? latestNews,
  String? seeAll,
  String? recommendedcommunities,
  String? mijncommunities,
  String? agenda,
  String? agendadetails,
  String? berichten,
  String? boardleden,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'Feed': feed,
      'LatestNews': latestNews,
      'seeAll': seeAll,
      'Recommendedcommunities': recommendedcommunities,
      'Mijncommunities': mijncommunities,
      'Agenda': agenda,
      'Agendadetails': agendadetails,
      'Berichten': berichten,
      'Boardleden': boardleden,
    }.withoutNulls,
  );

  return firestoreData;
}

class AppPreferenceRecordDocumentEquality
    implements Equality<AppPreferenceRecord> {
  const AppPreferenceRecordDocumentEquality();

  @override
  bool equals(AppPreferenceRecord? e1, AppPreferenceRecord? e2) {
    return e1?.feed == e2?.feed &&
        e1?.latestNews == e2?.latestNews &&
        e1?.seeAll == e2?.seeAll &&
        e1?.recommendedcommunities == e2?.recommendedcommunities &&
        e1?.mijncommunities == e2?.mijncommunities &&
        e1?.agenda == e2?.agenda &&
        e1?.agendadetails == e2?.agendadetails &&
        e1?.berichten == e2?.berichten &&
        e1?.boardleden == e2?.boardleden;
  }

  @override
  int hash(AppPreferenceRecord? e) => const ListEquality().hash([
        e?.feed,
        e?.latestNews,
        e?.seeAll,
        e?.recommendedcommunities,
        e?.mijncommunities,
        e?.agenda,
        e?.agendadetails,
        e?.berichten,
        e?.boardleden
      ]);

  @override
  bool isValidKey(Object? o) => o is AppPreferenceRecord;
}
