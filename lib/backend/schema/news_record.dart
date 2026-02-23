import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NewsRecord extends FirestoreRecord {
  NewsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "newsId" field.
  String? _newsId;
  String get newsId => _newsId ?? '';
  bool hasNewsId() => _newsId != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  bool hasContent() => _content != null;

  // "featuredImage" field.
  String? _featuredImage;
  String get featuredImage => _featuredImage ?? '';
  bool hasFeaturedImage() => _featuredImage != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "authorId" field.
  DocumentReference? _authorId;
  DocumentReference? get authorId => _authorId;
  bool hasAuthorId() => _authorId != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  bool hasType() => _type != null;

  // "videoUrl" field.
  String? _videoUrl;
  String get videoUrl => _videoUrl ?? '';
  bool hasVideoUrl() => _videoUrl != null;

  // "videoDuration" field.
  String? _videoDuration;
  String get videoDuration => _videoDuration ?? '';
  bool hasVideoDuration() => _videoDuration != null;

  // "videoThumbnail" field.
  String? _videoThumbnail;
  String get videoThumbnail => _videoThumbnail ?? '';
  bool hasVideoThumbnail() => _videoThumbnail != null;

  // "publishedAt" field.
  DateTime? _publishedAt;
  DateTime? get publishedAt => _publishedAt;
  bool hasPublishedAt() => _publishedAt != null;

  // "viewCount" field.
  int? _viewCount;
  int get viewCount => _viewCount ?? 0;
  bool hasViewCount() => _viewCount != null;

  // "likeCount" field.
  int? _likeCount;
  int get likeCount => _likeCount ?? 0;
  bool hasLikeCount() => _likeCount != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  bool hasUpdatedAt() => _updatedAt != null;

  void _initializeFields() {
    _newsId = snapshotData['newsId'] as String?;
    _title = snapshotData['title'] as String?;
    _content = snapshotData['content'] as String?;
    _featuredImage = snapshotData['featuredImage'] as String?;
    _category = snapshotData['category'] as String?;
    _authorId = snapshotData['authorId'] as DocumentReference?;
    _type = snapshotData['type'] as String?;
    _videoUrl = snapshotData['videoUrl'] as String?;
    _videoDuration = snapshotData['videoDuration'] as String?;
    _videoThumbnail = snapshotData['videoThumbnail'] as String?;
    _publishedAt = snapshotData['publishedAt'] as DateTime?;
    _viewCount = castToType<int>(snapshotData['viewCount']);
    _likeCount = castToType<int>(snapshotData['likeCount']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _updatedAt = snapshotData['updatedAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('news');

  static Stream<NewsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NewsRecord.fromSnapshot(s));

  static Future<NewsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NewsRecord.fromSnapshot(s));

  static NewsRecord fromSnapshot(DocumentSnapshot snapshot) => NewsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NewsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NewsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NewsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NewsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNewsRecordData({
  String? newsId,
  String? title,
  String? content,
  String? featuredImage,
  String? category,
  DocumentReference? authorId,
  String? type,
  String? videoUrl,
  String? videoDuration,
  String? videoThumbnail,
  DateTime? publishedAt,
  int? viewCount,
  int? likeCount,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'newsId': newsId,
      'title': title,
      'content': content,
      'featuredImage': featuredImage,
      'category': category,
      'authorId': authorId,
      'type': type,
      'videoUrl': videoUrl,
      'videoDuration': videoDuration,
      'videoThumbnail': videoThumbnail,
      'publishedAt': publishedAt,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class NewsRecordDocumentEquality implements Equality<NewsRecord> {
  const NewsRecordDocumentEquality();

  @override
  bool equals(NewsRecord? e1, NewsRecord? e2) {
    return e1?.newsId == e2?.newsId &&
        e1?.title == e2?.title &&
        e1?.content == e2?.content &&
        e1?.featuredImage == e2?.featuredImage &&
        e1?.category == e2?.category &&
        e1?.authorId == e2?.authorId &&
        e1?.type == e2?.type &&
        e1?.videoUrl == e2?.videoUrl &&
        e1?.videoDuration == e2?.videoDuration &&
        e1?.videoThumbnail == e2?.videoThumbnail &&
        e1?.publishedAt == e2?.publishedAt &&
        e1?.viewCount == e2?.viewCount &&
        e1?.likeCount == e2?.likeCount &&
        e1?.createdAt == e2?.createdAt &&
        e1?.updatedAt == e2?.updatedAt;
  }

  @override
  int hash(NewsRecord? e) => const ListEquality().hash([
        e?.newsId,
        e?.title,
        e?.content,
        e?.featuredImage,
        e?.category,
        e?.authorId,
        e?.type,
        e?.videoUrl,
        e?.videoDuration,
        e?.videoThumbnail,
        e?.publishedAt,
        e?.viewCount,
        e?.likeCount,
        e?.createdAt,
        e?.updatedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is NewsRecord;
}
