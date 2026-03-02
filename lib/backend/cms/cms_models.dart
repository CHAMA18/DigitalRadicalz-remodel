/// CMS Data Models for digitalradicalz CMS integration
/// These models map CMS responses to app-friendly data structures

import 'package:flutter/foundation.dart';

/// Base CMS response wrapper
class CmsResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final CmsPagination? pagination;

  CmsResponse({
    required this.success,
    this.message,
    this.data,
    this.pagination,
  });
}

/// Pagination info from CMS
class CmsPagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int perPage;
  final bool hasMore;

  CmsPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.perPage,
    required this.hasMore,
  });

  factory CmsPagination.fromJson(Map<String, dynamic> json) => CmsPagination(
    currentPage: json['current_page'] ?? json['page'] ?? 1,
    totalPages: json['total_pages'] ?? json['pages'] ?? 1,
    totalItems: json['total_items'] ?? json['total'] ?? 0,
    perPage: json['per_page'] ?? json['limit'] ?? 10,
    hasMore: json['has_more'] ?? (json['current_page'] ?? 1) < (json['total_pages'] ?? 1),
  );
}

/// CMS News/Article model
class CmsNews {
  final String id;
  final String title;
  final String content;
  final String? excerpt;
  final String? featuredImage;
  final String? category;
  final String? authorId;
  final String? authorName;
  final String? type; // 'article', 'video', etc.
  final String? videoUrl;
  final String? videoDuration;
  final String? videoThumbnail;
  final DateTime? publishedAt;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final bool isFeatured;

  CmsNews({
    required this.id,
    required this.title,
    required this.content,
    this.excerpt,
    this.featuredImage,
    this.category,
    this.authorId,
    this.authorName,
    this.type,
    this.videoUrl,
    this.videoDuration,
    this.videoThumbnail,
    this.publishedAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.isFeatured = false,
  });

  factory CmsNews.fromJson(Map<String, dynamic> json) {
    return CmsNews(
      id: (json['id'] ?? json['_id'] ?? json['newsId'] ?? '').toString(),
      title: _firstNonEmptyString([
            json['title'],
            json['name'],
            json['headline'],
            json['news_title'],
            json['article_title'],
          ]) ??
          '',
      content: _firstNonEmptyString([
            json['content'],
            json['body'],
            json['description'],
            json['article_content'],
            json['long_description'],
          ]) ??
          '',
      excerpt: _firstNonEmptyString([
        json['excerpt'],
        json['summary'],
        json['short_description'],
        json['subtitle'],
        json['sub_title'],
      ]),
      featuredImage: _extractImageUrl(
        json['featured_image'] ??
            json['featuredImage'] ??
            json['image'] ??
            json['thumbnail'] ??
            json['featured_media'],
      ),
      category: _firstNonEmptyString([
        json['category'],
        json['category_name'],
        json['news_category'],
        json['type_name'],
      ]),
      authorId: json['author_id']?.toString() ?? json['authorId']?.toString(),
      authorName: _firstNonEmptyString([
        json['author_name'],
        json['author']?['name'],
        json['authorName'],
        json['created_by_name'],
      ]),
      type: json['type'] ?? json['content_type'] ?? 'article',
      videoUrl: json['video_url'] ?? json['videoUrl'] ?? json['video'],
      videoDuration: json['video_duration'] ?? json['videoDuration'] ?? json['duration'],
      videoThumbnail: _extractImageUrl(
        json['video_thumbnail'] ?? json['videoThumbnail'] ?? json['thumbnail'],
      ),
      publishedAt: _parseDate(json['published_at'] ?? json['publishedAt'] ?? json['date']),
      viewCount: _parseInt(json['view_count'] ?? json['viewCount'] ?? json['views']) ?? 0,
      likeCount: _parseInt(json['like_count'] ?? json['likeCount'] ?? json['likes']) ?? 0,
      commentCount: _parseInt(
            json['comment_count'] ??
                json['commentCount'] ??
                json['comments'] ??
                json['comments_count'],
          ) ??
          0,
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
      tags: _parseStringList(json['tags']),
      isFeatured: json['is_featured'] ?? json['isFeatured'] ?? json['featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'excerpt': excerpt,
    'featuredImage': featuredImage,
    'category': category,
    'authorId': authorId,
    'authorName': authorName,
    'type': type,
    'videoUrl': videoUrl,
    'videoDuration': videoDuration,
    'videoThumbnail': videoThumbnail,
    'publishedAt': publishedAt?.toIso8601String(),
    'viewCount': viewCount,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'tags': tags,
    'isFeatured': isFeatured,
  };
}

/// CMS Event model
class CmsEvent {
  final String id;
  final String title;
  final String description;
  final String? image;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? venue;
  final String? address;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? category;
  final String? organizerId;
  final String? organizerName;
  final bool ticketsAvailable;
  final double? ticketPrice;
  final DateTime? salesEndTime;
  final bool isFeatured;
  final String status;
  final int? capacity;
  final int? attendeesCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CmsTicketType> ticketTypes;

  CmsEvent({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.date,
    this.startTime,
    this.endTime,
    this.venue,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.category,
    this.organizerId,
    this.organizerName,
    this.ticketsAvailable = false,
    this.ticketPrice,
    this.salesEndTime,
    this.isFeatured = false,
    this.status = 'active',
    this.capacity,
    this.attendeesCount,
    this.createdAt,
    this.updatedAt,
    this.ticketTypes = const [],
  });

  factory CmsEvent.fromJson(Map<String, dynamic> json) {
    return CmsEvent(
      id: (json['id'] ?? json['_id'] ?? json['eventId'] ?? '').toString(),
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? json['content'] ?? json['body'] ?? '',
      image: json['image'] ?? json['featured_image'] ?? json['thumbnail'] ?? json['poster'],
      date: _parseDate(json['date'] ?? json['event_date'] ?? json['start_date']),
      startTime: json['start_time'] ?? json['startTime'] ?? json['time'],
      endTime: json['end_time'] ?? json['endTime'],
      venue: json['venue'] ?? json['location'] ?? json['place'],
      address: json['address'] ?? json['street_address'],
      city: json['city'] ?? json['location_city'],
      latitude: _parseDouble(json['latitude'] ?? json['lat'] ?? json['coordinates']?['lat']),
      longitude: _parseDouble(json['longitude'] ?? json['lng'] ?? json['coordinates']?['lng']),
      category: json['category'] ?? json['event_type'],
      organizerId: json['organizer_id']?.toString() ?? json['organizerId']?.toString(),
      organizerName: json['organizer_name'] ?? json['organizer']?['name'] ?? json['organizerName'],
      ticketsAvailable: json['tickets_available'] ?? json['ticketsAvailable'] ?? json['has_tickets'] ?? false,
      ticketPrice: _parseDouble(json['ticket_price'] ?? json['ticketPrice'] ?? json['price']),
      salesEndTime: _parseDate(json['sales_end_time'] ?? json['salesEndTime'] ?? json['ticket_deadline']),
      isFeatured: json['is_featured'] ?? json['isFeatured'] ?? json['featured'] ?? false,
      status: json['status'] ?? 'active',
      capacity: _parseInt(json['capacity'] ?? json['max_attendees']),
      attendeesCount: _parseInt(json['attendees_count'] ?? json['attendees'] ?? json['registered']),
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
      ticketTypes: (json['ticket_types'] ?? json['ticketTypes'] ?? [])
          .map<CmsTicketType>((t) => CmsTicketType.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'image': image,
    'date': date?.toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
    'venue': venue,
    'address': address,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'category': category,
    'organizerId': organizerId,
    'organizerName': organizerName,
    'ticketsAvailable': ticketsAvailable,
    'ticketPrice': ticketPrice,
    'salesEndTime': salesEndTime?.toIso8601String(),
    'isFeatured': isFeatured,
    'status': status,
    'capacity': capacity,
    'attendeesCount': attendeesCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

/// CMS Ticket Type model
class CmsTicketType {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int? quantity;
  final int? sold;
  final bool isActive;

  CmsTicketType({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.quantity,
    this.sold,
    this.isActive = true,
  });

  factory CmsTicketType.fromJson(Map<String, dynamic> json) => CmsTicketType(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    name: json['name'] ?? json['title'] ?? '',
    description: json['description'],
    price: _parseDouble(json['price']) ?? 0.0,
    quantity: _parseInt(json['quantity'] ?? json['available']),
    sold: _parseInt(json['sold'] ?? json['tickets_sold']),
    isActive: json['is_active'] ?? json['active'] ?? true,
  );
}

/// CMS Product model
class CmsProduct {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final String? category;
  final int quantity;
  final String? sizeCapacity;
  final bool inStock;
  final double? rating;
  final int reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final Map<String, dynamic> attributes;

  CmsProduct({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.images = const [],
    required this.price,
    this.discountPrice,
    this.category,
    this.quantity = 0,
    this.sizeCapacity,
    this.inStock = true,
    this.rating,
    this.reviewCount = 0,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.attributes = const {},
  });

  factory CmsProduct.fromJson(Map<String, dynamic> json) {
    return CmsProduct(
      id: (json['id'] ?? json['_id'] ?? json['productId'] ?? '').toString(),
      name: json['name'] ?? json['Name'] ?? json['title'] ?? '',
      description: json['description'] ?? json['Description'] ?? json['content'],
      image: json['image'] ?? json['Image'] ?? json['featured_image'] ?? json['thumbnail'],
      images: _parseStringList(json['images'] ?? json['gallery']),
      price: _parseDouble(json['price'] ?? json['Price']) ?? 0.0,
      discountPrice: _parseDouble(json['discount_price'] ?? json['discountPrice'] ?? json['Discountprice'] ?? json['sale_price']),
      category: json['category'] ?? json['Category'] ?? json['category_name'],
      quantity: _parseInt(json['quantity'] ?? json['Quantity'] ?? json['stock']) ?? 0,
      sizeCapacity: json['size_capacity'] ?? json['Sizecapacity'] ?? json['size'] ?? json['variant'],
      inStock: json['in_stock'] ?? json['inStock'] ?? ((json['quantity'] ?? json['Quantity'] ?? 1) > 0),
      rating: _parseDouble(json['rating'] ?? json['average_rating']),
      reviewCount: _parseInt(json['review_count'] ?? json['reviews_count']) ?? 0,
      createdAt: _parseDate(json['created_at'] ?? json['createdAt'] ?? json['Date']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
      tags: _parseStringList(json['tags']),
      attributes: json['attributes'] ?? json['meta'] ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'images': images,
    'price': price,
    'discountPrice': discountPrice,
    'category': category,
    'quantity': quantity,
    'sizeCapacity': sizeCapacity,
    'inStock': inStock,
    'rating': rating,
    'reviewCount': reviewCount,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'tags': tags,
    'attributes': attributes,
  };

  /// Get effective price (discount if available)
  double get effectivePrice => discountPrice ?? price;

  /// Check if product is on sale
  bool get isOnSale => discountPrice != null && discountPrice! < price;

  /// Get discount percentage
  int get discountPercentage {
    if (!isOnSale) return 0;
    return (((price - discountPrice!) / price) * 100).round();
  }
}

/// CMS Media/Video model
class CmsMedia {
  final String id;
  final String title;
  final String? description;
  final String type; // 'video', 'audio', 'image', 'document'
  final String url;
  final String? thumbnailUrl;
  final String? duration;
  final String? category;
  final int viewCount;
  final int likeCount;
  final bool isFeatured;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

  CmsMedia({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.duration,
    this.category,
    this.viewCount = 0,
    this.likeCount = 0,
    this.isFeatured = false,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
  });

  factory CmsMedia.fromJson(Map<String, dynamic> json) {
    return CmsMedia(
      id: (json['id'] ?? json['_id'] ?? json['mediaId'] ?? '').toString(),
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? json['content'],
      type: json['type'] ?? json['media_type'] ?? 'video',
      url: json['url'] ?? json['file_url'] ?? json['video_url'] ?? json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? json['thumbnailUrl'] ?? json['thumbnail'] ?? json['poster'],
      duration: json['duration'] ?? json['video_duration'],
      category: json['category'] ?? json['category_name'],
      viewCount: _parseInt(json['view_count'] ?? json['viewCount'] ?? json['views']) ?? 0,
      likeCount: _parseInt(json['like_count'] ?? json['likeCount'] ?? json['likes']) ?? 0,
      isFeatured: json['is_featured'] ?? json['isFeatured'] ?? json['featured'] ?? false,
      publishedAt: _parseDate(json['published_at'] ?? json['publishedAt']),
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
      tags: _parseStringList(json['tags']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'url': url,
    'thumbnailUrl': thumbnailUrl,
    'duration': duration,
    'category': category,
    'viewCount': viewCount,
    'likeCount': likeCount,
    'isFeatured': isFeatured,
    'publishedAt': publishedAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'tags': tags,
  };
}

/// CMS Community/Post model
class CmsCommunityPost {
  final String id;
  final String? authorId;
  final String? authorName;
  final String? authorImage;
  final String? content;
  final String? image;
  final List<String> images;
  final String? communityId;
  final String? communityName;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isPinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;

  CmsCommunityPost({
    required this.id,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.content,
    this.image,
    this.images = const [],
    this.communityId,
    this.communityName,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isPinned = false,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
  });

  factory CmsCommunityPost.fromJson(Map<String, dynamic> json) {
    return CmsCommunityPost(
      id: (json['id'] ?? json['_id'] ?? json['postId'] ?? '').toString(),
      authorId: json['author_id']?.toString() ?? json['authorId']?.toString() ?? json['user_id']?.toString(),
      authorName: json['author_name'] ?? json['author']?['name'] ?? json['user']?['name'] ?? json['authorName'],
      authorImage: json['author_image'] ?? json['author']?['image'] ?? json['user']?['avatar'] ?? json['authorImage'],
      content: json['content'] ?? json['body'] ?? json['text'] ?? json['description'],
      image: json['image'] ?? json['featured_image'] ?? json['media'],
      images: _parseStringList(json['images'] ?? json['gallery'] ?? json['media_urls']),
      communityId: json['community_id']?.toString() ?? json['communityId']?.toString(),
      communityName: json['community_name'] ?? json['community']?['name'] ?? json['communityName'],
      likeCount: _parseInt(json['like_count'] ?? json['likeCount'] ?? json['likes']) ?? 0,
      commentCount: _parseInt(json['comment_count'] ?? json['commentCount'] ?? json['comments']) ?? 0,
      shareCount: _parseInt(json['share_count'] ?? json['shareCount'] ?? json['shares']) ?? 0,
      isPinned: json['is_pinned'] ?? json['isPinned'] ?? json['pinned'] ?? false,
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
      tags: _parseStringList(json['tags']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorId': authorId,
    'authorName': authorName,
    'authorImage': authorImage,
    'content': content,
    'image': image,
    'images': images,
    'communityId': communityId,
    'communityName': communityName,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'shareCount': shareCount,
    'isPinned': isPinned,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'tags': tags,
  };
}

/// CMS Course/Module model
class CmsCourse {
  final String id;
  final String title;
  final String? description;
  final String? image;
  final String? instructorId;
  final String? instructorName;
  final String? category;
  final double? price;
  final String? duration;
  final int moduleCount;
  final int enrolledCount;
  final double? rating;
  final bool isFeatured;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CmsCourseModule> modules;

  CmsCourse({
    required this.id,
    required this.title,
    this.description,
    this.image,
    this.instructorId,
    this.instructorName,
    this.category,
    this.price,
    this.duration,
    this.moduleCount = 0,
    this.enrolledCount = 0,
    this.rating,
    this.isFeatured = false,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
    this.modules = const [],
  });

  factory CmsCourse.fromJson(Map<String, dynamic> json) {
    return CmsCourse(
      id: (json['id'] ?? json['_id'] ?? json['courseId'] ?? '').toString(),
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? json['content'],
      image: json['image'] ?? json['featured_image'] ?? json['thumbnail'],
      instructorId: json['instructor_id']?.toString() ?? json['instructorId']?.toString(),
      instructorName: json['instructor_name'] ?? json['instructor']?['name'] ?? json['instructorName'],
      category: json['category'] ?? json['category_name'],
      price: _parseDouble(json['price']),
      duration: json['duration'] ?? json['total_duration'],
      moduleCount: _parseInt(json['module_count'] ?? json['modules_count'] ?? json['lessons_count']) ?? 0,
      enrolledCount: _parseInt(json['enrolled_count'] ?? json['students_count'] ?? json['enrollments']) ?? 0,
      rating: _parseDouble(json['rating'] ?? json['average_rating']),
      isFeatured: json['is_featured'] ?? json['isFeatured'] ?? json['featured'] ?? false,
      status: json['status'] ?? 'active',
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
      modules: (json['modules'] ?? json['lessons'] ?? [])
          .map<CmsCourseModule>((m) => CmsCourseModule.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// CMS Course Module model
class CmsCourseModule {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? duration;
  final int order;
  final bool isCompleted;

  CmsCourseModule({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.videoUrl,
    this.duration,
    this.order = 0,
    this.isCompleted = false,
  });

  factory CmsCourseModule.fromJson(Map<String, dynamic> json) => CmsCourseModule(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    title: json['title'] ?? json['name'] ?? '',
    description: json['description'],
    content: json['content'] ?? json['body'],
    videoUrl: json['video_url'] ?? json['videoUrl'] ?? json['video'],
    duration: json['duration'],
    order: _parseInt(json['order'] ?? json['position'] ?? json['sort_order']) ?? 0,
    isCompleted: json['is_completed'] ?? json['completed'] ?? false,
  );
}

// Helper functions for parsing
DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      debugPrint('Failed to parse date: $value');
      return null;
    }
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

List<String> _parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  if (value is String) {
    return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  return [];
}

String? _firstNonEmptyString(List<dynamic> values) {
  for (final value in values) {
    final normalized = _asNonEmptyString(value);
    if (normalized != null) {
      return normalized;
    }
  }
  return null;
}

String? _asNonEmptyString(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is num || value is bool) {
    return value.toString();
  }
  if (value is Map) {
    return _firstNonEmptyString([
      value['name'],
      value['title'],
      value['label'],
      value['value'],
    ]);
  }
  return null;
}

String? _extractImageUrl(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is List) {
    for (final item in value) {
      final candidate = _extractImageUrl(item);
      if (candidate != null) {
        return candidate;
      }
    }
    return null;
  }
  if (value is Map) {
    return _firstNonEmptyString([
      value['url'],
      value['src'],
      value['image'],
      value['secure_url'],
      value['path'],
      value['downloadURL'],
    ]);
  }
  return null;
}
