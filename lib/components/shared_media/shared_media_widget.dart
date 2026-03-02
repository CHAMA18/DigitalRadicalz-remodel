import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/components/shimmer_loaders/shimmer_loaders.dart';

class SharedMediaWidget extends StatefulWidget {
  const SharedMediaWidget({
    super.key,
    required this.chatRef,
    required this.chatTitle,
  });

  final DocumentReference chatRef;
  final String chatTitle;

  @override
  State<SharedMediaWidget> createState() => _SharedMediaWidgetState();
}

class _SharedMediaWidgetState extends State<SharedMediaWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderRadius: 20.0,
          buttonSize: 40.0,
          icon: Icon(
            Icons.chevron_left,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ffTranslate(context, 'Shared Media'),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              widget.chatTitle,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: FlutterFlowTheme.of(context).primary,
          unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
          indicatorColor: FlutterFlowTheme.of(context).primary,
          tabs: [
            Tab(text: ffTranslate(context, 'Images')),
            Tab(text: ffTranslate(context, 'Audio')),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: StreamBuilder<List<ChatmessagesRecord>>(
          stream: queryChatmessagesRecord(
            parent: widget.chatRef,
            queryBuilder: (chatmessagesRecord) =>
                chatmessagesRecord.orderBy('timestamp', descending: true),
          ),
          builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                ffTranslate(context, 'Unable to load media'),
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: ChatPageShimmer());
          }

          final messages = snapshot.data!;

          // Filter messages with images
          final messagesWithImages =
              messages.where((m) => m.images.isNotEmpty).toList();

          // Extract all images with their sender info
          final allImages = <Map<String, dynamic>>[];
          for (final msg in messagesWithImages) {
            for (final imageUrl in msg.images) {
              allImages.add({
                'url': imageUrl,
                'sender': msg.nameofsender,
                'timestamp': msg.timestamp,
              });
            }
          }

          // Filter messages with voice
          final messagesWithVoice =
              messages.where((m) => m.voice.isNotEmpty).toList();

            return TabBarView(
              controller: _tabController,
              children: [
                // Images Tab
                _buildImagesGrid(context, allImages),
                // Audio Tab
                _buildAudioList(context, messagesWithVoice),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagesGrid(
      BuildContext context, List<Map<String, dynamic>> images) {
    if (images.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.photo_library_outlined,
        ffTranslate(context, 'No images shared'),
        ffTranslate(context, 'Images shared in this chat will appear here'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageData = images[index];
        return GestureDetector(
          onTap: () => _showImageFullScreen(context, imageData['url'] as String,
              imageData['sender'] as String, imageData['timestamp'] as DateTime?),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageData['url'] as String,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: FlutterFlowTheme.of(context).alternate,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: FlutterFlowTheme.of(context).alternate,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioList(
      BuildContext context, List<ChatmessagesRecord> messages) {
    if (messages.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.mic_none_outlined,
        ffTranslate(context, 'No audio shared'),
        ffTranslate(context, 'Voice messages shared in this chat will appear here'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.nameofsender.isNotEmpty
                          ? message.nameofsender
                          : ffTranslate(context, 'Unknown'),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    if (message.timestamp != null)
                      Text(
                        _formatDate(message.timestamp!),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40.0,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8.0),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageFullScreen(
      BuildContext context, String imageUrl, String sender, DateTime? timestamp) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullScreenImageView(
          imageUrl: imageUrl,
          sender: sender,
          timestamp: timestamp,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return ffTranslate(context, 'Yesterday');
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${ffTranslate(context, 'days ago')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _FullScreenImageView extends StatelessWidget {
  const _FullScreenImageView({
    required this.imageUrl,
    required this.sender,
    this.timestamp,
  });

  final String imageUrl;
  final String sender;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender.isNotEmpty ? sender : ffTranslate(context, 'Unknown'),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            if (timestamp != null)
              Text(
                '${timestamp!.day}/${timestamp!.month}/${timestamp!.year}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white54,
                  size: 64,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
