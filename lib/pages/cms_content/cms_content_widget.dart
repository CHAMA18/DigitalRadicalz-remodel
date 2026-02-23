import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_theme.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_icon_button.dart';
import 'package:digital_radicalz/flutter_flow/flutter_flow_util.dart';
import 'package:digital_radicalz/backend/cms/index.dart';
import 'package:digital_radicalz/components/cms/index.dart';
import 'package:digital_radicalz/components/navbar/navbar_widget.dart';
import 'package:digital_radicalz/auth/firebase_auth/auth_util.dart';
import 'package:digital_radicalz/components/profile/profile_widget.dart';
import 'package:digital_radicalz/index.dart';
import 'cms_content_model.dart';
export 'cms_content_model.dart';

/// CMS Content page displaying content from digitalradicalz CMS
class CmsContentWidget extends StatefulWidget {
  const CmsContentWidget({super.key});

  static String routeName = 'CmsContent';
  static String routePath = '/cms-content';

  @override
  State<CmsContentWidget> createState() => _CmsContentWidgetState();
}

class _CmsContentWidgetState extends State<CmsContentWidget>
    with SingleTickerProviderStateMixin {
  late CmsContentModel _model;
  late TabController _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CmsContentModel());
    _tabController = TabController(length: 5, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContent();
    });
  }

  Future<void> _loadContent() async {
    final provider = Provider.of<CmsProvider>(context, listen: false);
    await Future.wait([
      provider.fetchNews(refresh: true),
      provider.fetchEvents(refresh: true),
      provider.fetchProducts(refresh: true),
      provider.fetchMedia(refresh: true),
      provider.fetchCourses(refresh: true),
    ]);
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 193.91,
                height: 48.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: Image.asset(
                      'assets/images/Digital_radicalz_(1).png',
                    ).image,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.chat_bubble_outline_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pushNamed(ChatWidget.routeName);
                      },
                    ),
                  ),
                  AuthUserStreamWidget(
                    builder: (context) => InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 0.98,
                                  child: const ProfileWidget(),
                                ),
                              ),
                            );
                          },
                        ).then((value) => safeSetState(() {}));
                      },
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(
                              valueOrDefault<String>(
                                currentUserPhoto,
                                'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                              ),
                            ).image,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
          elevation: 2.0,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: FlutterFlowTheme.of(context).primary,
            unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
            labelStyle: FlutterFlowTheme.of(context).titleSmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 14,
            ),
            indicatorColor: FlutterFlowTheme.of(context).primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'News'),
              Tab(text: 'Events'),
              Tab(text: 'Products'),
              Tab(text: 'Media'),
              Tab(text: 'Courses'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: [
                _buildNewsTab(context),
                _buildEventsTab(context),
                _buildProductsTab(context),
                _buildMediaTab(context),
                _buildCoursesTab(context),
              ],
            ),
            // Bottom navigation
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: wrapWithModel(
                model: _model.navbarModel,
                updateCallback: () => safeSetState(() {}),
                child: const NavbarWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsTab(BuildContext context) {
    return Consumer<CmsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingNews && provider.news.isEmpty) {
          return _buildLoadingState(context);
        }

        if (provider.newsError != null && provider.news.isEmpty) {
          return _buildErrorState(context, provider.newsError!, () {
            provider.fetchNews(refresh: true);
          });
        }

        if (provider.news.isEmpty) {
          return _buildEmptyState(context, 'No news available', Icons.article);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchNews(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.news.length,
            itemBuilder: (context, index) {
              final news = provider.news[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CmsNewsCard(
                  news: news,
                  isCompact: true,
                  onTap: () => _showNewsDetail(context, news),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEventsTab(BuildContext context) {
    return Consumer<CmsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingEvents && provider.events.isEmpty) {
          return _buildLoadingState(context);
        }

        if (provider.eventsError != null && provider.events.isEmpty) {
          return _buildErrorState(context, provider.eventsError!, () {
            provider.fetchEvents(refresh: true);
          });
        }

        if (provider.events.isEmpty) {
          return _buildEmptyState(context, 'No events available', Icons.event);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchEvents(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.events.length,
            itemBuilder: (context, index) {
              final event = provider.events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CmsEventCard(
                  event: event,
                  onTap: () => _showEventDetail(context, event),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductsTab(BuildContext context) {
    return Consumer<CmsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingProducts && provider.products.isEmpty) {
          return _buildLoadingState(context);
        }

        if (provider.productsError != null && provider.products.isEmpty) {
          return _buildErrorState(context, provider.productsError!, () {
            provider.fetchProducts(refresh: true);
          });
        }

        if (provider.products.isEmpty) {
          return _buildEmptyState(context, 'No products available', Icons.shopping_bag);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchProducts(refresh: true),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return CmsProductCard(
                product: product,
                isGridItem: true,
                onTap: () => _showProductDetail(context, product),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMediaTab(BuildContext context) {
    return Consumer<CmsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingMedia && provider.media.isEmpty) {
          return _buildLoadingState(context);
        }

        if (provider.mediaError != null && provider.media.isEmpty) {
          return _buildErrorState(context, provider.mediaError!, () {
            provider.fetchMedia(refresh: true);
          });
        }

        if (provider.media.isEmpty) {
          return _buildEmptyState(context, 'No media available', Icons.play_circle);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchMedia(refresh: true),
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: provider.media.length,
            itemBuilder: (context, index) {
              final media = provider.media[index];
              return CmsMediaCard(
                media: media,
                onTap: () => _showMediaDetail(context, media),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCoursesTab(BuildContext context) {
    return Consumer<CmsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingCourses && provider.courses.isEmpty) {
          return _buildLoadingState(context);
        }

        if (provider.coursesError != null && provider.courses.isEmpty) {
          return _buildErrorState(context, provider.coursesError!, () {
            provider.fetchCourses(refresh: true);
          });
        }

        if (provider.courses.isEmpty) {
          return _buildEmptyState(context, 'No courses available', Icons.school);
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchCourses(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.courses.length,
            itemBuilder: (context, index) {
              final course = provider.courses[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCourseCard(context, course),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, CmsCourse course) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              width: double.infinity,
              height: 140,
              child: course.image != null && course.image!.isNotEmpty
                  ? Image.network(
                      course.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.school,
                          size: 48,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    )
                  : Container(
                      color: FlutterFlowTheme.of(context).alternate,
                      child: Icon(
                        Icons.school,
                        size: 48,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (course.category != null && course.category!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      course.category!,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    fontSize: 18,
                  ),
                ),
                if (course.description != null && course.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    course.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.video_library,
                      size: 16,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.moduleCount} modules',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.people,
                      size: 16,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.enrolledCount} enrolled',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
                if (course.price != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R${course.price!.toStringAsFixed(0)}',
                        style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Enroll Now',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: FlutterFlowTheme.of(context).primary,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load content',
              style: FlutterFlowTheme.of(context).titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewsDetail(BuildContext context, CmsNews news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNewsDetailSheet(context, news),
    );
  }

  Widget _buildNewsDetailSheet(BuildContext context, CmsNews news) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Image
                if (news.featuredImage != null && news.featuredImage!.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      news.featuredImage!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.category != null && news.category!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            news.category!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      Text(
                        news.title,
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (news.authorName != null) ...[
                            Icon(
                              Icons.person,
                              size: 16,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              news.authorName!,
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${news.viewCount} views',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        news.content,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEventDetail(BuildContext context, CmsEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  CmsEventCard(event: event, showTicketInfo: true),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About this event',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          event.description,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProductDetail(BuildContext context, CmsProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (product.image != null && product.image!.isNotEmpty)
                    Image.network(
                      product.image!,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.shopping_bag,
                          size: 64,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.category != null)
                          Text(
                            product.category!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'R${product.effectivePrice.toStringAsFixed(2)}',
                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                            if (product.isOnSale) ...[
                              const SizedBox(width: 12),
                              Text(
                                'R${product.price.toStringAsFixed(2)}',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (product.description != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Description',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description!,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMediaDetail(BuildContext context, CmsMedia media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryText.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Video/Audio placeholder or thumbnail
                  Stack(
                    children: [
                      if (media.thumbnailUrl != null && media.thumbnailUrl!.isNotEmpty)
                        Image.network(
                          media.thumbnailUrl!,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 250,
                            color: FlutterFlowTheme.of(context).alternate,
                            child: Icon(
                              Icons.play_circle,
                              size: 64,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 250,
                          color: FlutterFlowTheme.of(context).alternate,
                          child: Center(
                            child: Icon(
                              media.type == 'video' ? Icons.videocam : Icons.headphones,
                              size: 64,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                          ),
                        ),
                      // Play button overlay
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (media.category != null)
                          Text(
                            media.category!,
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          media.title,
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${media.viewCount} views',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.favorite,
                              size: 16,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${media.likeCount} likes',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            if (media.duration != null) ...[
                              const SizedBox(width: 16),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                media.duration!,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (media.description != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Description',
                            style: FlutterFlowTheme.of(context).titleMedium.override(
                              font: GoogleFonts.inter(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            media.description!,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
