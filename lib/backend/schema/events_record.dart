import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EventsRecord extends FirestoreRecord {
  EventsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "eventId" field.
  String? _eventId;
  String get eventId => _eventId ?? '';
  bool hasEventId() => _eventId != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  bool hasDate() => _date != null;

  // "endTime" field.
  String? _endTime;
  String get endTime => _endTime ?? '';
  bool hasEndTime() => _endTime != null;

  // "startTime" field.
  String? _startTime;
  String get startTime => _startTime ?? '';
  bool hasStartTime() => _startTime != null;

  // "venue" field.
  String? _venue;
  String get venue => _venue ?? '';
  bool hasVenue() => _venue != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "coordinates" field.
  LatLng? _coordinates;
  LatLng? get coordinates => _coordinates;
  bool hasCoordinates() => _coordinates != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "organizerId" field.
  DocumentReference? _organizerId;
  DocumentReference? get organizerId => _organizerId;
  bool hasOrganizerId() => _organizerId != null;

  // "ticketsAvailable" field.
  bool? _ticketsAvailable;
  bool get ticketsAvailable => _ticketsAvailable ?? false;
  bool hasTicketsAvailable() => _ticketsAvailable != null;

  // "salesEndTime" field.
  DateTime? _salesEndTime;
  DateTime? get salesEndTime => _salesEndTime;
  bool hasSalesEndTime() => _salesEndTime != null;

  // "featured" field.
  bool? _featured;
  bool get featured => _featured ?? false;
  bool hasFeatured() => _featured != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  // "tixkedprice" field.
  DocumentReference? _tixkedprice;
  DocumentReference? get tixkedprice => _tixkedprice;
  bool hasTixkedprice() => _tixkedprice != null;

  // "communityref" field.
  DocumentReference? _communityref;
  DocumentReference? get communityref => _communityref;
  bool hasCommunityref() => _communityref != null;

  void _initializeFields() {
    _eventId = snapshotData['eventId'] as String?;
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _image = snapshotData['image'] as String?;
    _date = snapshotData['date'] as DateTime?;
    _endTime = snapshotData['endTime'] as String?;
    _startTime = snapshotData['startTime'] as String?;
    _venue = snapshotData['venue'] as String?;
    _address = snapshotData['address'] as String?;
    _city = snapshotData['city'] as String?;
    _coordinates = snapshotData['coordinates'] as LatLng?;
    _category = snapshotData['category'] as String?;
    _organizerId = snapshotData['organizerId'] as DocumentReference?;
    _ticketsAvailable = snapshotData['ticketsAvailable'] as bool?;
    _salesEndTime = snapshotData['salesEndTime'] as DateTime?;
    _featured = snapshotData['featured'] as bool?;
    _status = snapshotData['status'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
    _tixkedprice = snapshotData['tixkedprice'] as DocumentReference?;
    _communityref = snapshotData['communityref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Events');

  static Stream<EventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EventsRecord.fromSnapshot(s));

  static Future<EventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EventsRecord.fromSnapshot(s));

  static EventsRecord fromSnapshot(DocumentSnapshot snapshot) => EventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEventsRecordData({
  String? eventId,
  String? title,
  String? description,
  String? image,
  DateTime? date,
  String? endTime,
  String? startTime,
  String? venue,
  String? address,
  String? city,
  LatLng? coordinates,
  String? category,
  DocumentReference? organizerId,
  bool? ticketsAvailable,
  DateTime? salesEndTime,
  bool? featured,
  String? status,
  DateTime? createdAt,
  DateTime? updatedAt,
  DocumentReference? tixkedprice,
  DocumentReference? communityref,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'eventId': eventId,
      'title': title,
      'description': description,
      'image': image,
      'date': date,
      'endTime': endTime,
      'startTime': startTime,
      'venue': venue,
      'address': address,
      'city': city,
      'coordinates': coordinates,
      'category': category,
      'organizerId': organizerId,
      'ticketsAvailable': ticketsAvailable,
      'salesEndTime': salesEndTime,
      'featured': featured,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tixkedprice': tixkedprice,
      'communityref': communityref,
    }.withoutNulls,
  );

  return firestoreData;
}

class EventsRecordDocumentEquality implements Equality<EventsRecord> {
  const EventsRecordDocumentEquality();

  @override
  bool equals(EventsRecord? e1, EventsRecord? e2) {
    return e1?.eventId == e2?.eventId &&
        e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.image == e2?.image &&
        e1?.date == e2?.date &&
        e1?.endTime == e2?.endTime &&
        e1?.startTime == e2?.startTime &&
        e1?.venue == e2?.venue &&
        e1?.address == e2?.address &&
        e1?.city == e2?.city &&
        e1?.coordinates == e2?.coordinates &&
        e1?.category == e2?.category &&
        e1?.organizerId == e2?.organizerId &&
        e1?.ticketsAvailable == e2?.ticketsAvailable &&
        e1?.salesEndTime == e2?.salesEndTime &&
        e1?.featured == e2?.featured &&
        e1?.status == e2?.status &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt &&
        e1?.tixkedprice == e2?.tixkedprice &&
        e1?.communityref == e2?.communityref;
  }

  @override
  int hash(EventsRecord? e) => const ListEquality().hash([
        e?.eventId,
        e?.title,
        e?.description,
        e?.image,
        e?.date,
        e?.endTime,
        e?.startTime,
        e?.venue,
        e?.address,
        e?.city,
        e?.coordinates,
        e?.category,
        e?.organizerId,
        e?.ticketsAvailable,
        e?.salesEndTime,
        e?.featured,
        e?.status,
        e?.createdAt,
        e?.updatedAt,
        e?.tixkedprice,
        e?.communityref
      ]);

  @override
  bool isValidKey(Object? o) => o is EventsRecord;
}
