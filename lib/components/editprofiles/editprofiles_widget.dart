import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'editprofiles_model.dart';
export 'editprofiles_model.dart';

class EditprofilesWidget extends StatefulWidget {
  const EditprofilesWidget({super.key});

  @override
  State<EditprofilesWidget> createState() => _EditprofilesWidgetState();
}

class _EditprofilesWidgetState extends State<EditprofilesWidget> {
  late EditprofilesModel _model;
  bool _didSeedInitialValues = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditprofilesModel());

    _model.usernameTextController ??= TextEditingController();
    _model.usernameFocusNode ??= FocusNode();

    _model.emailchangeTextController ??= TextEditingController();
    _model.emailchangeFocusNode ??= FocusNode();

    _model.streetchangeTextController ??= TextEditingController();
    _model.streetchangeFocusNode ??= FocusNode();

    _model.numberstreetTextController ??= TextEditingController();
    _model.numberstreetFocusNode ??= FocusNode();

    _model.townnameTextController ??= TextEditingController();
    _model.townnameFocusNode ??= FocusNode();

    _model.birthdayTextController ??= TextEditingController();
    _model.birthdayFocusNode ??= FocusNode();

    _model.phonnumberTextController ??= TextEditingController();
    _model.phonnumberFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _parseAndSetPhoneNumber(String phone) {
    if (phone.isEmpty) return;
    
    // Try to find a matching country code
    CountryCode? matchedCountry;
    String remainingNumber = phone;
    
    // Sort by dial code length (longest first) to match more specific codes first
    final sortedCountries = List<CountryCode>.from(countryCodes)
      ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
    
    for (final country in sortedCountries) {
      if (phone.startsWith(country.dialCode)) {
        matchedCountry = country;
        remainingNumber = phone.substring(country.dialCode.length).trim();
        break;
      }
    }
    
    if (matchedCountry != null) {
      _model.selectedCountryCode = matchedCountry;
      _model.phonnumberTextController!.text = remainingNumber;
    } else {
      // No country code found, just set the phone number as is
      _model.phonnumberTextController!.text = phone;
    }
  }

  void _seedInitialValuesIfReady() {
    if (_didSeedInitialValues || currentUserDocument == null) {
      return;
    }

    final user = currentUserDocument!;

    if (_model.usernameTextController!.text.trim().isEmpty) {
      _model.usernameTextController!.text = user.displayName;
    }
    if (_model.emailchangeTextController!.text.trim().isEmpty) {
      _model.emailchangeTextController!.text = user.email;
    }
    if (_model.streetchangeTextController!.text.trim().isEmpty) {
      _model.streetchangeTextController!.text = user.addressname;
    }
    if (_model.numberstreetTextController!.text.trim().isEmpty) {
      _model.numberstreetTextController!.text = user.addressnumber;
    }
    if (_model.townnameTextController!.text.trim().isEmpty) {
      _model.townnameTextController!.text = user.town;
    }
    if (_model.phonnumberTextController!.text.trim().isEmpty && user.phoneNumber.isNotEmpty) {
      // Parse existing phone number to extract country code
      final phone = user.phoneNumber;
      _parseAndSetPhoneNumber(phone);
    }
    if (user.birthday != null && _model.birthdayTextController!.text.isEmpty) {
      _model.datePicked = user.birthday;
      _model.birthdayTextController!.text =
          dateTimeFormat('MM/dd/yyyy', user.birthday);
    }

    _didSeedInitialValues = true;
  }

  Future<void> _pickBirthday() async {
    final initialDate = _model.datePicked ??
        currentUserDocument?.birthday ??
        getCurrentTimestamp;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return wrapInMaterialDatePickerTheme(
          context,
          child!,
          headerBackgroundColor: FlutterFlowTheme.of(context).primary,
          headerForegroundColor: FlutterFlowTheme.of(context).info,
          headerTextStyle: FlutterFlowTheme.of(context).headlineLarge.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineLarge.fontStyle,
                ),
                fontSize: 32.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).headlineLarge.fontStyle,
              ),
          pickerBackgroundColor:
              FlutterFlowTheme.of(context).secondaryBackground,
          pickerForegroundColor: FlutterFlowTheme.of(context).primaryText,
          selectedDateTimeBackgroundColor: FlutterFlowTheme.of(context).primary,
          selectedDateTimeForegroundColor: FlutterFlowTheme.of(context).info,
          actionButtonForegroundColor: FlutterFlowTheme.of(context).primaryText,
          iconSize: 24.0,
        );
      },
    );

    if (pickedDate == null) return;

    safeSetState(() {
      _model.datePicked =
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      _model.birthdayTextController?.text =
          dateTimeFormat('MM/dd/yyyy', _model.datePicked);
    });
  }

  void _showCountryPicker(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final searchController = TextEditingController();
    List<CountryCode> filteredCountries = List.from(countryCodes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12.0),
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: theme.alternate,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Country',
                    style: theme.titleMedium.override(
                      font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search country...',
                      hintStyle: theme.labelMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                        color: theme.secondaryText,
                        letterSpacing: 0.0,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.secondaryText,
                        size: 20.0,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      filled: true,
                      fillColor: theme.primaryBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: theme.bodyMedium,
                    onChanged: (value) {
                      setModalState(() {
                        filteredCountries = countryCodes
                            .where((c) =>
                                c.name.toLowerCase().contains(value.toLowerCase()) ||
                                c.dialCode.contains(value) ||
                                c.code.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (ctx, index) {
                      final country = filteredCountries[index];
                      final isSelected = _model.selectedCountryCode?.code == country.code;
                      return InkWell(
                        onTap: () {
                          safeSetState(() {
                            _model.selectedCountryCode = country;
                          });
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: theme.alternate.withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                country.flag,
                                style: const TextStyle(fontSize: 24.0),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                country.dialCode,
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  color: isSelected
                                      ? theme.primary
                                      : theme.secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8.0),
                                Icon(
                                  Icons.check_circle,
                                  color: theme.primary,
                                  size: 20.0,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickAndUploadProfileImage() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      maxWidth: 220.0,
      maxHeight: 220.0,
      allowPhoto: true,
      includeDimensions: true,
    );
    if (selectedMedia == null ||
        !selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      return;
    }

    safeSetState(() => _model.isDataUploading_uploadDataI74 = true);
    var selectedUploadedFiles = <FFUploadedFile>[];

    try {
      selectedUploadedFiles = selectedMedia
          .map(
            (m) => FFUploadedFile(
              name: m.storagePath.split('/').last,
              bytes: m.bytes,
              height: m.dimensions?.height,
              width: m.dimensions?.width,
              blurHash: m.blurHash,
            ),
          )
          .toList();
    } finally {
      _model.isDataUploading_uploadDataI74 = false;
    }

    if (selectedUploadedFiles.length != selectedMedia.length) {
      safeSetState(() {});
      return;
    }

    safeSetState(() {
      _model.uploadedLocalFile_uploadDataI74 = selectedUploadedFiles.first;
    });

    try {
      if (mounted) {
        showUploadMessage(context, 'Uploading photo...', showLoading: true);
      }

      final prevUrl = currentUserPhoto;
      final originalPath = selectedMedia.first.storagePath;
      final ext = originalPath.contains('.')
          ? '.${originalPath.split('.').last}'
          : '.jpg';
      final safePath =
          'users/$currentUserUid/profile_${DateTime.now().millisecondsSinceEpoch}$ext';

      String? downloadUrl;
      try {
        downloadUrl = await uploadData(safePath, selectedMedia.first.bytes);
      } on FirebaseException catch (fe) {
        debugPrint(
            '[EditProfile] Firebase Storage error: code=${fe.code}, message=${fe.message}, path=$safePath');
        rethrow;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      if (downloadUrl == null) {
        if (mounted) {
          showUploadMessage(context, 'Upload failed');
        }
        return;
      }

      await currentUserReference?.update(
        createUsersRecordData(photoUrl: downloadUrl),
      );

      try {
        await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);
      } catch (e) {
        debugPrint('[EditProfile] Auth photoURL update failed: $e');
      }

      try {
        if (prevUrl.isNotEmpty) {
          await NetworkImage(prevUrl).evict();
        }
        await NetworkImage(downloadUrl).evict();
      } catch (e) {
        debugPrint('[EditProfile] Image cache eviction error: $e');
      }

      if (mounted) {
        showUploadMessage(context, 'Profile photo updated');
      }
      safeSetState(() {});
    } catch (e) {
      debugPrint('[EditProfile] Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showUploadMessage(context, 'Upload failed');
      }
    }
  }

  Future<void> _saveProfileChanges() async {
    if (currentUserReference == null) {
      return;
    }

    final displayName = _model.usernameTextController.text.trim();

    if (!mounted) return;

    // Combine country code with phone number
    final phoneNumber = _model.phonnumberTextController.text.trim();
    final countryCode = _model.selectedCountryCode?.dialCode ?? '+1';
    final fullPhoneNumber = phoneNumber.isNotEmpty 
        ? '$countryCode $phoneNumber'
        : '';

    await currentUserReference!.update(
      createUsersRecordData(
        addressname: _model.streetchangeTextController.text.trim(),
        addressnumber: _model.numberstreetTextController.text.trim(),
        town: _model.townnameTextController.text.trim(),
        birthday: _model.datePicked,
        phoneNumber: fullPhoneNumber,
        displayName: displayName,
      ),
    );

    if (displayName.isNotEmpty) {
      try {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);
      } catch (e) {
        debugPrint('[EditProfile] Auth displayName update failed: $e');
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully',
          style: TextStyle(color: FlutterFlowTheme.of(context).primaryText),
        ),
        duration: const Duration(milliseconds: 2600),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ),
    );
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    Widget? suffixIcon,
    IconData? prefixIcon,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: theme.labelMedium.override(
        font: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        fontSize: 15.0,
        letterSpacing: 0.0,
        fontWeight: FontWeight.w500,
        fontStyle: theme.labelMedium.fontStyle,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(
              prefixIcon,
              size: 20.0,
              color: theme.secondaryText,
            ),
      suffixIcon: suffixIcon,
      contentPadding:
          const EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 14.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.6),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8.0),
      child: Text(
        text,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final hasLocal = _model.uploadedLocalFile_uploadDataI74.bytes != null &&
        _model.uploadedLocalFile_uploadDataI74.bytes!.isNotEmpty;
    final photo = currentUserPhoto;

    final imageProvider = hasLocal
        ? Image.memory(_model.uploadedLocalFile_uploadDataI74.bytes!).image
        : (photo.isNotEmpty
            ? Image.network(photo).image
            : const AssetImage(
                'assets/images/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
              ) as ImageProvider);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: _pickAndUploadProfileImage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 112.0,
            height: 112.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                width: 4.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16.0,
                  color: FlutterFlowTheme.of(context)
                      .primary
                      .withValues(alpha: 0.24),
                  offset: const Offset(0.0, 6.0),
                ),
              ],
              image: DecorationImage(fit: BoxFit.cover, image: imageProvider),
            ),
          ),
          Positioned(
            right: -2.0,
            bottom: -2.0,
            child: Container(
              width: 34.0,
              height: 34.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  width: 2.0,
                ),
              ),
              child: Icon(
                Icons.edit_rounded,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthUserStreamWidget(
      builder: (context) {
        // Seed initial values when user data is available
        _seedInitialValuesIfReady();

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 0.0),
          child: Column(
            children: [
              Row(
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 12.0,
                    buttonSize: 42.0,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 18.0,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edit Profile',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w700,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                        ),
                        Text('Keep your account details current',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsetsDirectional.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom + 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 18.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 18.0,
                              color: FlutterFlowTheme.of(context)
                                  .primaryText
                                  .withValues(alpha: 0.05),
                              offset: const Offset(0.0, 6.0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildAvatar(context),
                            const SizedBox(height: 14.0),
                            TextFormField(
                              controller: _model.usernameTextController,
                              focusNode: _model.usernameFocusNode,
                              textAlign: TextAlign.center,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                context,
                                hintText: ffTranslate(context, 'Your full name'),
                                prefixIcon: Icons.person_outline_rounded,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                              validator: _model.usernameTextControllerValidator
                                  .asValidator(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            14.0, 16.0, 14.0, 16.0),
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contact',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                            ),
                            const SizedBox(height: 12.0),
                            _label(context, 'Address'),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _model.streetchangeTextController,
                                    focusNode: _model.streetchangeFocusNode,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDecoration(
                                      context,
                                      hintText: ffTranslate(context, 'Street name'),
                                      prefixIcon: Icons.location_on_outlined,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    validator: _model
                                        .streetchangeTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                SizedBox(
                                  width: 100.0,
                                  child: TextFormField(
                                    controller:
                                        _model.numberstreetTextController,
                                    focusNode: _model.numberstreetFocusNode,
                                    textInputAction: TextInputAction.next,
                                    decoration: _inputDecoration(
                                      context,
                                      hintText: ffTranslate(context, 'No.'),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    validator: _model
                                        .numberstreetTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14.0),
                            _label(context, 'Town / City'),
                            TextFormField(
                              controller: _model.townnameTextController,
                              focusNode: _model.townnameFocusNode,
                              textInputAction: TextInputAction.next,
                              decoration: _inputDecoration(
                                context,
                                hintText: ffTranslate(context, 'Town name'),
                                prefixIcon: Icons.apartment_outlined,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              validator: _model.townnameTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 14.0),
                            _label(context, 'Birthday'),
                            TextFormField(
                              controller: _model.birthdayTextController,
                              focusNode: _model.birthdayFocusNode,
                              readOnly: true,
                              onTap: _pickBirthday,
                              decoration: _inputDecoration(
                                context,
                                hintText: ffTranslate(context, 'MM/DD/YYYY'),
                                prefixIcon: Icons.cake_outlined,
                                suffixIcon: InkWell(
                                  onTap: _pickBirthday,
                                  child: Icon(
                                    Icons.calendar_month_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              validator: _model.birthdayTextControllerValidator
                                  .asValidator(context),
                            ),
                            const SizedBox(height: 14.0),
                            _label(context, 'Phone number'),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _showCountryPicker(context),
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 14.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context).alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _model.selectedCountryCode?.flag ?? '🇺🇸',
                                          style: const TextStyle(fontSize: 20.0),
                                        ),
                                        const SizedBox(width: 6.0),
                                        Text(
                                          _model.selectedCountryCode?.dialCode ?? '+1',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                              ),
                                        ),
                                        const SizedBox(width: 4.0),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 20.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: TextFormField(
                                    controller: _model.phonnumberTextController,
                                    focusNode: _model.phonnumberFocusNode,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    decoration: _inputDecoration(
                                      context,
                                      hintText: ffTranslate(context, '555 123 4567'),
                                      prefixIcon: Icons.phone_outlined,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                    validator: _model
                                        .phonnumberTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      FFButtonWidget(
                        onPressed: _saveProfileChanges,
                        text: ffTranslate(context, 'Save Changes'),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 52.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
