/// CMS Provider for state management
/// Manages loading states and caching of CMS content across the app

import 'package:flutter/foundation.dart';
import 'cms_models.dart';
import 'cms_service.dart';

/// Provider for CMS content state management
class CmsProvider extends ChangeNotifier {
  static CmsProvider? _instance;
  static CmsProvider get instance => _instance ??= CmsProvider._();
  
  CmsProvider._();
  
  // Loading states
  bool _isLoadingNews = false;
  bool _isLoadingEvents = false;
  bool _isLoadingProducts = false;
  bool _isLoadingMedia = false;
  bool _isLoadingPosts = false;
  bool _isLoadingCourses = false;
  
  bool get isLoadingNews => _isLoadingNews;
  bool get isLoadingEvents => _isLoadingEvents;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingMedia => _isLoadingMedia;
  bool get isLoadingPosts => _isLoadingPosts;
  bool get isLoadingCourses => _isLoadingCourses;
  
  // Cached data
  List<CmsNews> _news = [];
  List<CmsNews> _featuredNews = [];
  List<CmsNews> _videos = [];
  List<CmsEvent> _events = [];
  List<CmsEvent> _upcomingEvents = [];
  List<CmsProduct> _products = [];
  List<CmsMedia> _media = [];
  List<CmsCommunityPost> _posts = [];
  List<CmsCourse> _courses = [];
  
  // Getters for cached data
  List<CmsNews> get news => _news;
  List<CmsNews> get featuredNews => _featuredNews;
  List<CmsNews> get videos => _videos;
  List<CmsEvent> get events => _events;
  List<CmsEvent> get upcomingEvents => _upcomingEvents;
  List<CmsProduct> get products => _products;
  List<CmsMedia> get media => _media;
  List<CmsCommunityPost> get posts => _posts;
  List<CmsCourse> get courses => _courses;
  
  // Error states
  String? _newsError;
  String? _eventsError;
  String? _productsError;
  String? _mediaError;
  String? _postsError;
  String? _coursesError;
  
  String? get newsError => _newsError;
  String? get eventsError => _eventsError;
  String? get productsError => _productsError;
  String? get mediaError => _mediaError;
  String? get postsError => _postsError;
  String? get coursesError => _coursesError;
  
  // Pagination tracking
  int _newsPage = 1;
  int _eventsPage = 1;
  int _productsPage = 1;
  int _mediaPage = 1;
  int _postsPage = 1;
  int _coursesPage = 1;
  
  bool _hasMoreNews = true;
  bool _hasMoreEvents = true;
  bool _hasMoreProducts = true;
  bool _hasMoreMedia = true;
  bool _hasMorePosts = true;
  bool _hasMoreCourses = true;
  
  bool get hasMoreNews => _hasMoreNews;
  bool get hasMoreEvents => _hasMoreEvents;
  bool get hasMoreProducts => _hasMoreProducts;
  bool get hasMoreMedia => _hasMoreMedia;
  bool get hasMorePosts => _hasMorePosts;
  bool get hasMoreCourses => _hasMoreCourses;
  
  // ============ NEWS ============
  
  /// Fetch news articles (with refresh option)
  Future<void> fetchNews({bool refresh = false}) async {
    if (_isLoadingNews) return;
    
    if (refresh) {
      _newsPage = 1;
      _hasMoreNews = true;
      _news = [];
    }
    
    if (!_hasMoreNews) return;
    
    _isLoadingNews = true;
    _newsError = null;
    notifyListeners();
    
    try {
      final results = await cmsService.getNews(page: _newsPage);
      
      if (results.isEmpty) {
        _hasMoreNews = false;
      } else {
        _news = refresh ? results : [..._news, ...results];
        _newsPage++;
      }
    } catch (e) {
      _newsError = 'Failed to load news: $e';
      debugPrint(_newsError);
    } finally {
      _isLoadingNews = false;
      notifyListeners();
    }
  }
  
  /// Fetch featured news
  Future<void> fetchFeaturedNews() async {
    try {
      _featuredNews = await cmsService.getFeaturedNews();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load featured news: $e');
    }
  }
  
  /// Fetch video content
  Future<void> fetchVideos({bool refresh = false}) async {
    if (refresh) {
      _videos = [];
    }
    
    try {
      final results = await cmsService.getVideos();
      _videos = results;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load videos: $e');
    }
  }
  
  // ============ EVENTS ============
  
  /// Fetch events (with refresh option)
  Future<void> fetchEvents({bool refresh = false}) async {
    if (_isLoadingEvents) return;
    
    if (refresh) {
      _eventsPage = 1;
      _hasMoreEvents = true;
      _events = [];
    }
    
    if (!_hasMoreEvents) return;
    
    _isLoadingEvents = true;
    _eventsError = null;
    notifyListeners();
    
    try {
      final results = await cmsService.getEvents(page: _eventsPage);
      
      if (results.isEmpty) {
        _hasMoreEvents = false;
      } else {
        _events = refresh ? results : [..._events, ...results];
        _eventsPage++;
      }
    } catch (e) {
      _eventsError = 'Failed to load events: $e';
      debugPrint(_eventsError);
    } finally {
      _isLoadingEvents = false;
      notifyListeners();
    }
  }
  
  /// Fetch upcoming events
  Future<void> fetchUpcomingEvents() async {
    try {
      _upcomingEvents = await cmsService.getUpcomingEvents();
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load upcoming events: $e');
    }
  }
  
  // ============ PRODUCTS ============
  
  /// Fetch products (with refresh option)
  Future<void> fetchProducts({bool refresh = false, String? category}) async {
    if (_isLoadingProducts) return;
    
    if (refresh) {
      _productsPage = 1;
      _hasMoreProducts = true;
      _products = [];
    }
    
    if (!_hasMoreProducts) return;
    
    _isLoadingProducts = true;
    _productsError = null;
    notifyListeners();
    
    try {
      final results = await cmsService.getProducts(
        page: _productsPage,
        category: category,
      );
      
      if (results.isEmpty) {
        _hasMoreProducts = false;
      } else {
        _products = refresh ? results : [..._products, ...results];
        _productsPage++;
      }
    } catch (e) {
      _productsError = 'Failed to load products: $e';
      debugPrint(_productsError);
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }
  
  // ============ MEDIA ============
  
  /// Fetch media content (with refresh option)
  Future<void> fetchMedia({bool refresh = false, String? type}) async {
    if (_isLoadingMedia) return;
    
    if (refresh) {
      _mediaPage = 1;
      _hasMoreMedia = true;
      _media = [];
    }
    
    if (!_hasMoreMedia) return;
    
    _isLoadingMedia = true;
    _mediaError = null;
    notifyListeners();
    
    try {
      final results = await cmsService.getMedia(
        page: _mediaPage,
        type: type,
      );
      
      if (results.isEmpty) {
        _hasMoreMedia = false;
      } else {
        _media = refresh ? results : [..._media, ...results];
        _mediaPage++;
      }
    } catch (e) {
      _mediaError = 'Failed to load media: $e';
      debugPrint(_mediaError);
    } finally {
      _isLoadingMedia = false;
      notifyListeners();
    }
  }
  
  // ============ POSTS ============
  
  /// Fetch community posts (with refresh option)
  Future<void> fetchPosts({bool refresh = false, String? communityId}) async {
    if (_isLoadingPosts) return;
    
    if (refresh) {
      _postsPage = 1;
      _hasMorePosts = true;
      _posts = [];
    }
    
    if (!_hasMorePosts) return;
    
    _isLoadingPosts = true;
    _postsError = null;
    notifyListeners();
    
    try {
      final results = await cmsService.getPosts(
        page: _postsPage,
        communityId: communityId,
      );
      
      if (results.isEmpty) {
        _hasMorePosts = false;
      } else {
        _posts = refresh ? results : [..._posts, ...results];
        _postsPage++;
      }
    } catch (e) {
      _postsError = 'Failed to load posts: $e';
      debugPrint(_postsError);
    } finally {
      _isLoadingPosts = false;
      notifyListeners();
    }
  }
  
  // ============ COURSES ============
  
  /// Fetch courses (with refresh option)
  Future<void> fetchCourses({bool refresh = false}) async {
    if (_isLoadingCourses) return;
    
    if (refresh) {
      _coursesPage = 1;
      _hasMoreCourses = true;
      _courses = [];
    }
    
    if (!_hasMoreCourses) return;
    
    _isLoadingCourses = true;
    _coursesError = null;
    notifyListeners();
    
    try {
      final results = await cmsService.getCourses(page: _coursesPage);
      
      if (results.isEmpty) {
        _hasMoreCourses = false;
      } else {
        _courses = refresh ? results : [..._courses, ...results];
        _coursesPage++;
      }
    } catch (e) {
      _coursesError = 'Failed to load courses: $e';
      debugPrint(_coursesError);
    } finally {
      _isLoadingCourses = false;
      notifyListeners();
    }
  }
  
  // ============ UTILITIES ============
  
  /// Refresh all content
  Future<void> refreshAll() async {
    await Future.wait([
      fetchNews(refresh: true),
      fetchFeaturedNews(),
      fetchEvents(refresh: true),
      fetchUpcomingEvents(),
      fetchProducts(refresh: true),
      fetchMedia(refresh: true),
      fetchPosts(refresh: true),
      fetchCourses(refresh: true),
    ]);
  }
  
  /// Clear all cached data
  void clearAll() {
    _news = [];
    _featuredNews = [];
    _videos = [];
    _events = [];
    _upcomingEvents = [];
    _products = [];
    _media = [];
    _posts = [];
    _courses = [];
    
    _newsPage = 1;
    _eventsPage = 1;
    _productsPage = 1;
    _mediaPage = 1;
    _postsPage = 1;
    _coursesPage = 1;
    
    _hasMoreNews = true;
    _hasMoreEvents = true;
    _hasMoreProducts = true;
    _hasMoreMedia = true;
    _hasMorePosts = true;
    _hasMoreCourses = true;
    
    _newsError = null;
    _eventsError = null;
    _productsError = null;
    _mediaError = null;
    _postsError = null;
    _coursesError = null;
    
    cmsService.clearCache();
    notifyListeners();
  }
}

/// Convenience getter for CMS provider
CmsProvider get cmsProvider => CmsProvider.instance;
