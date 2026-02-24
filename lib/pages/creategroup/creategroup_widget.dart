import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';

import 'creategroup_model.dart';
export 'creategroup_model.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  static String routeName = 'creategroup';
  static String routePath = '/creategroup';

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late CreateGroupPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateGroupPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
    );
    if (!mounted) return;

    if (selectedMedia != null && selectedMedia.isNotEmpty) {
      if (!validateFileFormat(selectedMedia.first.storagePath, context)) {
        return;
      }
      setState(() => _model.isUploading = true);
      try {
        showUploadMessage(context, 'Uploading file...', showLoading: true);
        final uploadedUrl = await uploadData(
          selectedMedia.first.storagePath,
          selectedMedia.first.bytes,
        );
        if (!mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (uploadedUrl != null) {
          setState(() => _model.uploadedImageUrl = uploadedUrl);
          showUploadMessage(context, 'Upload complete');
        } else {
          showUploadMessage(context, 'Upload failed');
        }
      } finally {
        setState(() => _model.isUploading = false);
      }
    }
  }

  InputDecoration _fieldDecoration(
    FlutterFlowTheme theme, {
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.bodyMedium.override(
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: theme.secondaryText,
        size: 20.0,
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.6),
        borderRadius: BorderRadius.circular(14),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.6),
        borderRadius: BorderRadius.circular(14),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          elevation: 0,
          leading: FlutterFlowIconButton(
            borderRadius: 20,
            buttonSize: 40,
            icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
            onPressed: () => context.safePop(),
          ),
          title: Text('Create a Group',
            style: theme.headlineSmall.override(
              font: GoogleFonts.interTight(
                fontWeight: FontWeight.w600,
                fontStyle: theme.headlineSmall.fontStyle,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          top: true,
          child: Form(
            key: _model.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: const Alignment(-1, -1),
                        end: const Alignment(1, 1),
                        colors: [
                          theme.primary.withValues(alpha: 0.16),
                          theme.secondaryBackground,
                        ],
                      ),
                      border: Border.all(
                        color: theme.primary.withValues(alpha: 0.24),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Group Identity',
                          style: theme.titleMedium.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.titleMedium.fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Design your group with a standout image, a clear name, and a compelling description.',
                          style: theme.bodySmall.override(
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cover Photo',
                        style: theme.labelLarge.override(
                          letterSpacing: 0.0,
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.alternate.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Optional',
                          style: theme.labelSmall.override(
                            letterSpacing: 0.0,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: 182,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.alternate,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            color: theme.primaryText.withValues(alpha: 0.06),
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _model.isUploading
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: FFShimmerLoadingIndicator(
                                      strokeWidth: 2.8,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('Uploading image...',
                                    style: theme.bodyMedium.override(
                                      color: theme.secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : (_model.uploadedImageUrl == null
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 62,
                                        height: 62,
                                        decoration: BoxDecoration(
                                          color: theme.alternate
                                              .withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 30,
                                          color: theme.secondaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text('Tap to upload',
                                        style: theme.titleSmall.override(
                                          letterSpacing: 0.0,
                                          color: theme.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Recommended: 1:1 or 16:9',
                                        style: theme.bodySmall.override(
                                          color: theme.secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        _model.uploadedImageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.52),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text('Change',
                                          style: theme.labelSmall.override(
                                            color: theme.info,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Group Name',
                    style: theme.labelLarge.override(
                      letterSpacing: 0.0,
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.titleController,
                    maxLength: 48,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: _fieldDecoration(
                      theme,
                      hintText: ffTranslate(context, 'Add a title to your group'),
                      prefixIcon: Icons.groups_outlined,
                    ),
                    style: theme.bodyMedium.override(letterSpacing: 0.0),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a group name';
                      }
                      if (val.trim().length < 3) {
                        return 'Group name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Description',
                    style: theme.labelLarge.override(
                      letterSpacing: 0.0,
                      color: theme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.descriptionController,
                    maxLines: 5,
                    minLines: 4,
                    maxLength: 220,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                    decoration: _fieldDecoration(
                      theme,
                      hintText: ffTranslate(context, 'Describe your group purpose, audience, and vibe'),
                      prefixIcon: Icons.edit_note_rounded,
                    ),
                    style: theme.bodyMedium.override(letterSpacing: 0.0),
                  ),
                  const SizedBox(height: 18),
                  FFButtonWidget(
                    onPressed: () async {
                      if (_model.isUploading) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please wait for the image upload to finish.'),
                            backgroundColor: theme.secondary,
                          ),
                        );
                        return;
                      }

                      if (!(_model.formKey.currentState?.validate() ?? false)) {
                        return;
                      }

                      final title = _model.titleController?.text.trim() ?? '';
                      final description =
                          _model.descriptionController?.text.trim() ?? '';

                      context.pushNamed(
                        AddMembersPage.routeName,
                        queryParameters: {
                          'groupTitle': title,
                          'groupDescription': description,
                          'groupImage': _model.uploadedImageUrl ?? '',
                        }.withoutNulls,
                      );
                    },
                    text: ffTranslate(context, 'Continue'),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56,
                      color: theme.primary,
                      textStyle: theme.titleSmall.override(
                        color: theme.info,
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.titleSmall.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddMembersPage extends StatefulWidget {
  const AddMembersPage(
      {super.key, this.groupTitle, this.groupDescription, this.groupImage});

  final String? groupTitle;
  final String? groupDescription;
  final String? groupImage;

  static String routeName = 'addmembers';
  static String routePath = '/addmembers';

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _unfocusNode = FocusNode();
  final Set<DocumentReference> _selected = {};
  final Map<DocumentReference, UsersRecord> _selectedUsers = {};

  @override
  void dispose() {
    _searchController.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final adminRef = currentUserReference;
    if (adminRef == null) return;
    if ((widget.groupTitle ?? '').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Group title required'),
            backgroundColor: FlutterFlowTheme.of(context).error),
      );
      return;
    }

    try {
      final memberRefs = <DocumentReference>{adminRef, ..._selected};
      // Build usernames list
      final usernames = <String>[];
      for (final ref in memberRefs) {
        if (_selectedUsers.containsKey(ref)) {
          usernames.add(_selectedUsers[ref]!.displayName.isNotEmpty
              ? _selectedUsers[ref]!.displayName
              : _selectedUsers[ref]!.email);
        } else if (ref == adminRef && currentUserDocument != null) {
          final name = currentUserDocument!.displayName.isNotEmpty
              ? currentUserDocument!.displayName
              : currentUserDocument!.email;
          usernames.add(name);
        }
      }

      final data = createGroupsRecordData(
        groupName: widget.groupTitle,
        groupDescription: widget.groupDescription,
        groupimage:
            (widget.groupImage ?? '').isEmpty ? null : widget.groupImage,
        adminId: adminRef,
        createdAt: getCurrentTimestamp,
        timestamp: getCurrentTimestamp,
      );
      final Map<String, dynamic> fullData = {
        ...data,
        'userid': memberRefs.toList(),
        'usernames': usernames,
        'Lastmessage': '',
        'lastmessageseenby': <DocumentReference>[],
      };

      final docRef = await GroupsRecord.collection.add(fullData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Group created'),
            backgroundColor: FlutterFlowTheme.of(context).primary,
          ),
        );
        context.pushNamed(
          GrouchatsWidget.routeName,
          queryParameters: {
            'receivedgroupchats':
                serializeParam(docRef, ParamType.DocumentReference),
          }.withoutNulls,
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create group. Please try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          elevation: 0,
          leading: FlutterFlowIconButton(
            borderRadius: 20,
            buttonSize: 40,
            icon: Icon(Icons.arrow_back_rounded, color: theme.primaryText),
            onPressed: () => context.safePop(),
          ),
          title: Text('Add Member',
            style: theme.headlineSmall.override(
              font: GoogleFonts.interTight(
                fontWeight: FontWeight.w600,
                fontStyle: theme.headlineSmall.fontStyle,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check, color: theme.primaryText),
              onPressed: _createGroup,
              tooltip: ffTranslate(context, 'Create group'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: ffTranslate(context, 'search for user'),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.alternate),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.primary, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  style: theme.bodyMedium.override(letterSpacing: 0.0),
                ),
              ),
              // Selected users row
              if (_selected.isNotEmpty)
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: _selected.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final ref = _selected.elementAt(index);
                      final user = _selectedUsers[ref];
                      final name = user?.displayName.isNotEmpty == true
                          ? user!.displayName
                          : (user?.email ?? 'User Name');
                      final photo = (user?.photoUrl ?? '').isNotEmpty
                          ? user!.photoUrl
                          : 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png';
                      return Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(photo),
                              ),
                              Positioned(
                                right: -4,
                                top: -4,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  splashRadius: 18,
                                  onPressed: () {
                                    setState(() {
                                      _selected.remove(ref);
                                      _selectedUsers.remove(ref);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 80,
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:
                                  theme.bodySmall.override(letterSpacing: 0.0),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Members',
                      style: theme.titleSmall.override(letterSpacing: 0.0)),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<UsersRecord>>(
                  stream: queryUsersRecord(
                    queryBuilder: (q) => q.orderBy('display_name').limit(100),
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: FFShimmerLoadingIndicator());
                    }
                    var users = snapshot.data!;
                    final term = _searchController.text.trim().toLowerCase();
                    if (term.isNotEmpty) {
                      users = users
                          .where((u) =>
                              (u.displayName.toLowerCase().contains(term) ||
                                  u.email.toLowerCase().contains(term)))
                          .toList();
                    }
                    // Hide current user from selection list
                    users = users
                        .where((u) => u.reference != currentUserReference)
                        .toList();

                    if (users.isEmpty) {
                      return Center(
                        child: Text('No users found',
                          style: theme.bodyMedium.override(letterSpacing: 0.0),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final selected = _selected.contains(user.reference);
                        final photo = user.photoUrl.isNotEmpty
                            ? user.photoUrl
                            : 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png';
                        final name = user.displayName.isNotEmpty
                            ? user.displayName
                            : user.email;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selected.remove(user.reference);
                                _selectedUsers.remove(user.reference);
                              } else {
                                _selected.add(user.reference);
                                _selectedUsers[user.reference] = user;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.alternate),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 22,
                                    backgroundImage: NetworkImage(photo)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: theme.bodyLarge
                                        .override(letterSpacing: 0.0),
                                  ),
                                ),
                                Checkbox(
                                  value: selected,
                                  onChanged: (v) {
                                    setState(() {
                                      if (v == true) {
                                        _selected.add(user.reference);
                                        _selectedUsers[user.reference] = user;
                                      } else {
                                        _selected.remove(user.reference);
                                        _selectedUsers.remove(user.reference);
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
