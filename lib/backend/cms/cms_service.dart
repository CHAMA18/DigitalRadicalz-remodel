/// CMS Service for digitalradicalz CMS integration
/// Handles all API calls to fetch content from the CMS

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cms_models.dart';

/// Configuration for the CMS API
class CmsConfig {
  /// Base URL of the CMS API
  static const String baseUrl = 'https://digitalradicalz.onrender.com';
  
  /// API endpoints - can be customized based on actual CMS structure
  static const String newsEndpoint = '/api/news';
  static const String eventsEndpoint = '/api/events';
  static const String productsEndpoint = '/api/products';
  static const String mediaEndpoint = '/api/media';
  static const String postsEndpoint = '/api/posts';
  static const String coursesEndpoint = '/api/courses';
  static const String categoriesEndpoint = '/api/categories';
  
  /// Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
  
  /// Default headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

/// Singleton CMS Service for fetching content
class CmsService {
  static CmsService? _instance;
  static CmsService get instance => _instance ??= CmsService._();
  
  CmsService._();
  
  final http.Client _client = http.Client();
  
  // Caching
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheValidity = Duration(minutes: 5);
  
  /// Check if cached data is still valid
  bool _isCacheValid(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheValidity;
  }
  
  /// Clear all cache
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }
  
  /// Generic API request method
  Future<Map<String, dynamic>?> _makeRequest(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool useCache = true,
  }) async {
    final cacheKey = '$endpoint?${queryParams?.toString() ?? ''}';
    
    // Check cache first
    if (useCache && _isCacheValid(cacheKey) && _cache.containsKey(cacheKey)) {
      debugPrint('CMS: Using cached data for $endpoint');
      return _cache[cacheKey] as Map<String, dynamic>?;
    }
    
    try {
      final uri = Uri.parse('${CmsConfig.baseUrl}$endpoint').replace(
        queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
      );
      
      debugPrint('CMS: Fetching $uri');
      
      final response = await _client
          .get(uri, headers: CmsConfig.headers)
          .timeout(CmsConfig.timeout);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Handle different response formats
        Map<String, dynamic> result;
        if (data is Map<String, dynamic>) {
          result = data;
        } else if (data is List) {
          result = {'data': data, 'success': true};
        } else {
          result = {'data': data, 'success': true};
        }
        
        // Cache the result
        _cache[cacheKey] = result;
        _cacheTimestamps[cacheKey] = DateTime.now();
        
        return result;
      } else {
        debugPrint('CMS Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      debugPrint('CMS: Request timeout for $endpoint');
      return null;
    } catch (e) {
      debugPrint('CMS Error: $e');
      return null;
    }
  }
  
  // ============ NEWS/ARTICLES ============
  
  /// Fetch all news articles
  Future<List<CmsNews>> getNews({
    int page = 1,
    int limit = 10,
    String? category,
    String? type,
    bool featuredOnly = false,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (featuredOnly) 'featured': true,
    };
    
    final response = await _makeRequest(CmsConfig.newsEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsNews.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch a single news article by ID
  Future<CmsNews?> getNewsById(String id) async {
    final response = await _makeRequest('${CmsConfig.newsEndpoint}/$id');
    if (response == null) return null;
    
    final data = _extractSingleData(response);
    if (data == null) return null;
    return CmsNews.fromJson(data);
  }
  
  /// Fetch featured news
  Future<List<CmsNews>> getFeaturedNews({int limit = 5}) async {
    return getNews(featuredOnly: true, limit: limit);
  }
  
  /// Fetch video content
  Future<List<CmsNews>> getVideos({int page = 1, int limit = 10}) async {
    return getNews(page: page, limit: limit, type: 'video');
  }
  
  // ============ EVENTS ============
  
  /// Fetch all events
  Future<List<CmsEvent>> getEvents({
    int page = 1,
    int limit = 10,
    String? category,
    bool upcomingOnly = false,
    bool featuredOnly = false,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (upcomingOnly) 'upcoming': true,
      if (featuredOnly) 'featured': true,
    };
    
    final response = await _makeRequest(CmsConfig.eventsEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsEvent.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch a single event by ID
  Future<CmsEvent?> getEventById(String id) async {
    final response = await _makeRequest('${CmsConfig.eventsEndpoint}/$id');
    if (response == null) return null;
    
    final data = _extractSingleData(response);
    if (data == null) return null;
    return CmsEvent.fromJson(data);
  }
  
  /// Fetch upcoming events
  Future<List<CmsEvent>> getUpcomingEvents({int limit = 10}) async {
    return getEvents(upcomingOnly: true, limit: limit);
  }
  
  /// Fetch featured events
  Future<List<CmsEvent>> getFeaturedEvents({int limit = 5}) async {
    return getEvents(featuredOnly: true, limit: limit);
  }
  
  // ============ PRODUCTS ============
  
  /// Fetch all products
  Future<List<CmsProduct>> getProducts({
    int page = 1,
    int limit = 10,
    String? category,
    bool inStockOnly = false,
    String? sortBy,
    String? sortOrder,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (inStockOnly) 'in_stock': true,
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    };
    
    final response = await _makeRequest(CmsConfig.productsEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsProduct.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch a single product by ID
  Future<CmsProduct?> getProductById(String id) async {
    final response = await _makeRequest('${CmsConfig.productsEndpoint}/$id');
    if (response == null) return null;
    
    final data = _extractSingleData(response);
    if (data == null) return null;
    return CmsProduct.fromJson(data);
  }
  
  /// Search products
  Future<List<CmsProduct>> searchProducts(String query, {int limit = 20}) async {
    final params = <String, dynamic>{
      'search': query,
      'q': query,
      'limit': limit,
    };
    
    final response = await _makeRequest(CmsConfig.productsEndpoint, queryParams: params, useCache: false);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsProduct.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch products on sale
  Future<List<CmsProduct>> getProductsOnSale({int limit = 10}) async {
    final params = <String, dynamic>{
      'on_sale': true,
      'limit': limit,
    };
    
    final response = await _makeRequest(CmsConfig.productsEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsProduct.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  // ============ MEDIA ============
  
  /// Fetch all media content
  Future<List<CmsMedia>> getMedia({
    int page = 1,
    int limit = 10,
    String? type, // 'video', 'audio', 'image'
    String? category,
    bool featuredOnly = false,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (featuredOnly) 'featured': true,
    };
    
    final response = await _makeRequest(CmsConfig.mediaEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsMedia.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch a single media item by ID
  Future<CmsMedia?> getMediaById(String id) async {
    final response = await _makeRequest('${CmsConfig.mediaEndpoint}/$id');
    if (response == null) return null;
    
    final data = _extractSingleData(response);
    if (data == null) return null;
    return CmsMedia.fromJson(data);
  }
  
  /// Fetch video content
  Future<List<CmsMedia>> getVideoMedia({int page = 1, int limit = 10}) async {
    return getMedia(page: page, limit: limit, type: 'video');
  }
  
  // ============ COMMUNITY POSTS ============
  
  /// Fetch community posts
  Future<List<CmsCommunityPost>> getPosts({
    int page = 1,
    int limit = 10,
    String? communityId,
    String? authorId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (communityId != null) 'community_id': communityId,
      if (authorId != null) 'author_id': authorId,
    };
    
    final response = await _makeRequest(CmsConfig.postsEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsCommunityPost.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch a single post by ID
  Future<CmsCommunityPost?> getPostById(String id) async {
    final response = await _makeRequest('${CmsConfig.postsEndpoint}/$id');
    if (response == null) return null;
    
    final data = _extractSingleData(response);
    if (data == null) return null;
    return CmsCommunityPost.fromJson(data);
  }
  
  // ============ COURSES ============
  
  /// Fetch all courses
  Future<List<CmsCourse>> getCourses({
    int page = 1,
    int limit = 10,
    String? category,
    bool featuredOnly = false,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (featuredOnly) 'featured': true,
    };
    
    final response = await _makeRequest(CmsConfig.coursesEndpoint, queryParams: params);
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((json) => CmsCourse.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  /// Fetch a single course by ID
  Future<CmsCourse?> getCourseById(String id) async {
    final response = await _makeRequest('${CmsConfig.coursesEndpoint}/$id');
    if (response == null) return null;
    
    final data = _extractSingleData(response);
    if (data == null) return null;
    return CmsCourse.fromJson(data);
  }
  
  // ============ CATEGORIES ============
  
  /// Fetch categories for a content type
  Future<List<String>> getCategories(String contentType) async {
    final response = await _makeRequest('${CmsConfig.categoriesEndpoint}/$contentType');
    if (response == null) return [];
    
    final data = _extractListData(response);
    return data.map((item) {
      if (item is String) return item;
      if (item is Map) return (item['name'] ?? item['title'] ?? '').toString();
      return item.toString();
    }).where((s) => s.isNotEmpty).toList();
  }
  
  // ============ SEARCH ============
  
  /// Global search across all content types
  Future<Map<String, List<dynamic>>> globalSearch(String query, {int limit = 10}) async {
    final results = <String, List<dynamic>>{
      'news': [],
      'events': [],
      'products': [],
      'media': [],
    };
    
    // Parallel requests for each content type
    final futures = await Future.wait([
      _searchContent(CmsConfig.newsEndpoint, query, limit),
      _searchContent(CmsConfig.eventsEndpoint, query, limit),
      _searchContent(CmsConfig.productsEndpoint, query, limit),
      _searchContent(CmsConfig.mediaEndpoint, query, limit),
    ]);
    
    results['news'] = futures[0].map((j) => CmsNews.fromJson(j as Map<String, dynamic>)).toList();
    results['events'] = futures[1].map((j) => CmsEvent.fromJson(j as Map<String, dynamic>)).toList();
    results['products'] = futures[2].map((j) => CmsProduct.fromJson(j as Map<String, dynamic>)).toList();
    results['media'] = futures[3].map((j) => CmsMedia.fromJson(j as Map<String, dynamic>)).toList();
    
    return results;
  }
  
  Future<List<dynamic>> _searchContent(String endpoint, String query, int limit) async {
    final response = await _makeRequest(
      endpoint,
      queryParams: {'search': query, 'q': query, 'limit': limit},
      useCache: false,
    );
    if (response == null) return [];
    return _extractListData(response);
  }
  
  // ============ HELPERS ============
  
  /// Extract list data from various response formats
  List<dynamic> _extractListData(Map<String, dynamic> response) {
    // Common response formats
    if (response['data'] is List) return response['data'] as List;
    if (response['items'] is List) return response['items'] as List;
    if (response['results'] is List) return response['results'] as List;
    if (response['records'] is List) return response['records'] as List;
    if (response['content'] is List) return response['content'] as List;
    
    // If the response itself is wrapped in a data key that contains an object with the actual list
    if (response['data'] is Map) {
      final data = response['data'] as Map<String, dynamic>;
      if (data['items'] is List) return data['items'] as List;
      if (data['results'] is List) return data['results'] as List;
    }
    
    // If response is a list at root level (shouldn't happen with our wrapper, but just in case)
    return [];
  }
  
  /// Extract single item data from response
  Map<String, dynamic>? _extractSingleData(Map<String, dynamic> response) {
    if (response['data'] is Map) return response['data'] as Map<String, dynamic>;
    if (response['item'] is Map) return response['item'] as Map<String, dynamic>;
    if (response['result'] is Map) return response['result'] as Map<String, dynamic>;
    
    // If the response itself contains the item data directly
    if (response.containsKey('id') || response.containsKey('_id')) {
      return response;
    }
    
    return null;
  }
  
  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Convenience getters for accessing CMS service
CmsService get cmsService => CmsService.instance;
