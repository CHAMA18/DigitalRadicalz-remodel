import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "interests" field.
  List<String>? _interests;
  List<String> get interests => _interests ?? const [];
  bool hasInterests() => _interests != null;

  // "allNotifications" field.
  bool? _allNotifications;
  bool get allNotifications => _allNotifications ?? false;
  bool hasAllNotifications() => _allNotifications != null;

  // "recommendedNotifications" field.
  bool? _recommendedNotifications;
  bool get recommendedNotifications => _recommendedNotifications ?? false;
  bool hasRecommendedNotifications() => _recommendedNotifications != null;

  // "communityPostsNotifications" field.
  bool? _communityPostsNotifications;
  bool get communityPostsNotifications => _communityPostsNotifications ?? false;
  bool hasCommunityPostsNotifications() => _communityPostsNotifications != null;

  // "walletBalance" field.
  double? _walletBalance;
  double get walletBalance => _walletBalance ?? 0.0;
  bool hasWalletBalance() => _walletBalance != null;

  // "userType" field.
  String? _userType;
  String get userType => _userType ?? '';
  bool hasUserType() => _userType != null;

  // "addressname" field.
  String? _addressname;
  String get addressname => _addressname ?? '';
  bool hasAddressname() => _addressname != null;

  // "addressnumber" field.
  String? _addressnumber;
  String get addressnumber => _addressnumber ?? '';
  bool hasAddressnumber() => _addressnumber != null;

  // "Town" field.
  String? _town;
  String get town => _town ?? '';
  bool hasTown() => _town != null;

  // "Birthday" field.
  DateTime? _birthday;
  DateTime? get birthday => _birthday;
  bool hasBirthday() => _birthday != null;

  // "numberofticket" field.
  int? _numberofticket;
  int get numberofticket => _numberofticket ?? 0;
  bool hasNumberofticket() => _numberofticket != null;

  // "following" field.
  List<DocumentReference>? _following;
  List<DocumentReference> get following => _following ?? const [];
  bool hasFollowing() => _following != null;

  // "communityjoined" field.
  DocumentReference? _communityjoined;
  DocumentReference? get communityjoined => _communityjoined;
  bool hasCommunityjoined() => _communityjoined != null;

  // "eventliked" field.
  List<DocumentReference>? _eventliked;
  List<DocumentReference> get eventliked => _eventliked ?? const [];
  bool hasEventliked() => _eventliked != null;

  // "interestss" field.
  List<DocumentReference>? _interestss;
  List<DocumentReference> get interestss => _interestss ?? const [];
  bool hasInterestss() => _interestss != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _interests = getDataList(snapshotData['interests']);
    _allNotifications = snapshotData['allNotifications'] as bool?;
    _recommendedNotifications =
        snapshotData['recommendedNotifications'] as bool?;
    _communityPostsNotifications =
        snapshotData['communityPostsNotifications'] as bool?;
    _walletBalance = castToType<double>(snapshotData['walletBalance']);
    _userType = snapshotData['userType'] as String?;
    _addressname = snapshotData['addressname'] as String?;
    _addressnumber = snapshotData['addressnumber'] as String?;
    _town = snapshotData['Town'] as String?;
    _birthday = snapshotData['Birthday'] as DateTime?;
    _numberofticket = castToType<int>(snapshotData['numberofticket']);
    _following = getDataList(snapshotData['following']);
    _communityjoined = snapshotData['communityjoined'] as DocumentReference?;
    _eventliked = getDataList(snapshotData['eventliked']);
    _interestss = getDataList(snapshotData['interestss']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  bool? allNotifications,
  bool? recommendedNotifications,
  bool? communityPostsNotifications,
  double? walletBalance,
  String? userType,
  String? addressname,
  String? addressnumber,
  String? town,
  DateTime? birthday,
  int? numberofticket,
  DocumentReference? communityjoined,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'allNotifications': allNotifications,
      'recommendedNotifications': recommendedNotifications,
      'communityPostsNotifications': communityPostsNotifications,
      'walletBalance': walletBalance,
      'userType': userType,
      'addressname': addressname,
      'addressnumber': addressnumber,
      'Town': town,
      'Birthday': birthday,
      'numberofticket': numberofticket,
      'communityjoined': communityjoined,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        listEquality.equals(e1?.interests, e2?.interests) &&
        e1?.allNotifications == e2?.allNotifications &&
        e1?.recommendedNotifications == e2?.recommendedNotifications &&
        e1?.communityPostsNotifications == e2?.communityPostsNotifications &&
        e1?.walletBalance == e2?.walletBalance &&
        e1?.userType == e2?.userType &&
        e1?.addressname == e2?.addressname &&
        e1?.addressnumber == e2?.addressnumber &&
        e1?.town == e2?.town &&
        e1?.birthday == e2?.birthday &&
        e1?.numberofticket == e2?.numberofticket &&
        listEquality.equals(e1?.following, e2?.following) &&
        e1?.communityjoined == e2?.communityjoined &&
        listEquality.equals(e1?.eventliked, e2?.eventliked) &&
        listEquality.equals(e1?.interestss, e2?.interestss);
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.interests,
        e?.allNotifications,
        e?.recommendedNotifications,
        e?.communityPostsNotifications,
        e?.walletBalance,
        e?.userType,
        e?.addressname,
        e?.addressnumber,
        e?.town,
        e?.birthday,
        e?.numberofticket,
        e?.following,
        e?.communityjoined,
        e?.eventliked,
        e?.interestss
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
