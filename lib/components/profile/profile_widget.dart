import '/auth/firebase_auth/auth_util.dart';
import '/components/aboutus1/aboutus1_widget.dart';
import '/components/editprofiles/editprofiles_widget.dart';
import '/components/interest/interest_widget.dart';
import '/components/my_ticket/my_ticket_widget.dart';
import '/components/settings3/settings3_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  Future<void> _openSheet(Widget child, {double heightFactor = 0.95}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(sheetContext),
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * heightFactor,
            child: child,
          ),
        );
      },
    ).then((_) => safeSetState(() {}));
  }

  Future<void> _logout() async {
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    if (!mounted) return;
    GoRouter.of(context).clearRedirectLocation();
    context.goNamedAuth(LoginWidget.routeName, context.mounted);
  }

  Future<void> _openLanguagePicker() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(ffTranslate(context, 'Select language')),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'system'),
            child: Text(ffTranslate(context, 'System default')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'en'),
            child: Text(ffTranslate(context, 'English')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'es'),
            child: Text(ffTranslate(context, 'Spanish')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'de'),
            child: Text(ffTranslate(context, 'German')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'fr'),
            child: Text(ffTranslate(context, 'French')),
          ),
        ],
      ),
    );

    if (selected == null) return;
    if (!mounted) return;

    final appState = FFAppState();
    if (selected == 'system') {
      appState.update(() {
        appState.useSystemLocale = true;
      });
      useSystemLanguage(context);
    } else {
      appState.update(() {
        appState.useSystemLocale = false;
        appState.appLocaleCode = selected;
      });
      setAppLanguage(context, selected);
    }

    safeSetState(() {});
  }

  Widget _menuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Future<void> Function() onTap,
    Color? accentColor,
    bool showChevron = true,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final iconColor = accentColor ?? theme.primaryText;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () async => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: iconColor, size: 20.0),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  title,
                  style: theme.bodyLarge.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    color: accentColor != null ? iconColor : theme.primaryText,
                  ),
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.secondaryText,
                  size: 22.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: theme.primaryText.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: theme.primaryText, size: 20.0),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  title,
                  style: theme.bodyLarge.override(
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeThumbColor: theme.secondaryBackground,
                activeTrackColor: theme.primary,
                inactiveTrackColor: theme.alternate,
                inactiveThumbColor: theme.secondaryBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(BuildContext context, List<Widget> children) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appState = FFAppState();
    final languageLabel = appState.useSystemLocale
        ? ffTranslate(context, 'System default')
        : ffLanguageName(context, appState.appLocaleCode);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
      ),
      child: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 14.0,
                    buttonSize: 42.0,
                    fillColor: theme.primaryBackground,
                    borderColor: theme.alternate,
                    borderWidth: 1.0,
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: theme.primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    ffTranslate(context, 'Profile'),
                    style: theme.titleMedium.override(
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14.0),
              AuthUserStreamWidget(
                builder: (context) {
                  final photo = currentUserPhoto;
                  final displayName = valueOrDefault<String>(
                    currentUserDisplayName,
                    ffTranslate(context, 'Unknown User'),
                  );
                  final email = valueOrDefault<String>(
                    currentUserEmail,
                    ffTranslate(context, 'No email linked'),
                  );

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primary.withValues(alpha: 0.18),
                          theme.secondary.withValues(alpha: 0.14),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22.0),
                      border: Border.all(
                        color: theme.primary.withValues(alpha: 0.16),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 88.0,
                          height: 88.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.secondaryBackground,
                              width: 3.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 16.0,
                                offset: const Offset(0.0, 6.0),
                              ),
                            ],
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (photo.isNotEmpty)
                                  ? Image.network(photo).image
                                  : Image.network(
                                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/bright-wave-ioj9xl/assets/gbh03g8a6d5k/placeholder-profile-icon-8qmjk1094ijhbem9-removebg-preview.png',
                                    ).image,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.titleLarge.override(
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.bodySmall.override(
                                  letterSpacing: 0.0,
                                  color: theme.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.secondaryBackground
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(999.0),
                                ),
                                child: Text(
                                  ffTranslate(
                                      context, 'DigitalRadicalz Member'),
                                  style: theme.labelSmall.override(
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                ffTranslate(context, 'Account'),
                style: theme.bodySmall.override(
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w700,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(height: 10.0),
              _sectionCard(
                context,
                [
                  _menuTile(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    title: ffTranslate(context, 'My Profile'),
                    onTap: () async {
                      await Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                body: const EditprofilesWidget(),
                              ),
                            ),
                          )
                          .then((_) => safeSetState(() {}));
                    },
                  ),
                  Divider(height: 1.0, color: theme.alternate),
                  _menuTile(
                    context: context,
                    icon: Icons.confirmation_number_outlined,
                    title: ffTranslate(context, 'Tickets'),
                    onTap: () async {
                      await Navigator.of(context, rootNavigator: true)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => const MyTicketWidget(),
                            ),
                          )
                          .then((_) => safeSetState(() {}));
                    },
                  ),
                  Divider(height: 1.0, color: theme.alternate),
                  _menuTile(
                    context: context,
                    icon: Icons.favorite_border_rounded,
                    title: ffTranslate(context, 'Interests'),
                    onTap: () =>
                        _openSheet(const InterestWidget(), heightFactor: 0.97),
                  ),
                  Divider(height: 1.0, color: theme.alternate),
                  _menuTile(
                    context: context,
                    icon: Icons.settings_outlined,
                    title: ffTranslate(context, 'Settings'),
                    onTap: () => _openSheet(const Settings3Widget()),
                  ),
                  Divider(height: 1.0, color: theme.alternate),
                  _toggleTile(
                    context: context,
                    icon: isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    title: ffTranslate(context, 'Dark Mode / Light Mode'),
                    value: isDarkMode,
                    onChanged: (enabled) async {
                      setDarkModeSetting(
                        context,
                        enabled ? ThemeMode.dark : ThemeMode.light,
                      );
                      safeSetState(() {});
                    },
                  ),
                  Divider(height: 1.0, color: theme.alternate),
                  _menuTile(
                    context: context,
                    icon: Icons.language_rounded,
                    title: ffTranslate(
                      context,
                      'Language ({language})',
                      replacements: {'language': languageLabel},
                    ),
                    onTap: _openLanguagePicker,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                ffTranslate(context, 'Support & Legal'),
                style: theme.bodySmall.override(
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w700,
                  color: theme.secondaryText,
                ),
              ),
              const SizedBox(height: 10.0),
              _sectionCard(
                context,
                [
                  _menuTile(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: ffTranslate(context, 'About Us'),
                    onTap: () async {
                      await Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                backgroundColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                body: const Aboutus1Widget(),
                              ),
                            ),
                          )
                          .then((_) => safeSetState(() {}));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: theme.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: theme.error.withValues(alpha: 0.20),
                    width: 1.0,
                  ),
                ),
                child: _menuTile(
                  context: context,
                  icon: Icons.logout_rounded,
                  title: ffTranslate(context, 'Log Out'),
                  accentColor: theme.error,
                  showChevron: false,
                  onTap: _logout,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
