import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'backend/cms/cms_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'flutter_flow/shimmering.dart';
import 'index.dart';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:rxdart/rxdart.dart';
import 'backend/backend.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => appState),
      ChangeNotifierProvider(create: (context) => CmsProvider.instance),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;
  Locale? _locale;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  
  StreamSubscription<int>? _unreadCountSubscription;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = digitalRadicalzFirebaseUserStream()
      ..listen((user) async {
        _appStateNotifier.update(user);
        
        if (user.loggedIn) {
          _startBadgeListener();
        } else {
          _stopBadgeListener();
          try {
            if (await FlutterAppBadger.isAppBadgeSupported()) {
              FlutterAppBadger.removeBadge();
            }
          } catch (e) {
            debugPrint('Error removing badge: $e');
          }
        }
      });
    jwtTokenStream.listen((_) {});

    // Initialize locale based on persisted app state
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final state = Provider.of<FFAppState>(context, listen: false);
      if (state.useSystemLocale) {
        _locale = null; // follow system
      } else {
        _locale = Locale(state.appLocaleCode);
      }
      safeSetState(() {});

      // Ensure unauthenticated users can read public Firestore data by
      // automatically signing in anonymously on app start (web-friendly).
      if (!loggedIn) {
        try {
          await authManager.signInAnonymously(context);
        } catch (e) {
          debugPrint('Auto anonymous sign-in failed: $e');
        }
      }
    });

    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();
    _unreadCountSubscription?.cancel();
    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  void setLocale(Locale? locale) => safeSetState(() {
        _locale = locale;
      });

  void _startBadgeListener() {
    _unreadCountSubscription?.cancel();
    _unreadCountSubscription = _getUnreadCountStream().listen((count) async {
      try {
        if (await FlutterAppBadger.isAppBadgeSupported()) {
          FlutterAppBadger.updateBadgeCount(count);
        }
      } catch (e) {
        debugPrint('Error updating badge count: $e');
      }
    });
  }

  void _stopBadgeListener() {
    _unreadCountSubscription?.cancel();
    _unreadCountSubscription = null;
  }

  /// Creates a combined stream of unread direct messages and group chats
  Stream<int> _getUnreadCountStream() {
    try {
      if (currentUserReference == null) {
        return Stream.value(0);
      }
      
      // Stream for unread direct messages
      final directMessagesStream = queryChatsRecord(
        queryBuilder: (chatsRecord) => chatsRecord.where(
          'userid',
          arrayContains: currentUserReference,
        ),
      ).handleError((error) {
        debugPrint('Error querying direct chats for unread count: $error');
        return <ChatsRecord>[];
      }).map((chats) {
        int count = 0;
        for (final chat in chats) {
          if (!chat.lastmessageseenby.contains(currentUserReference)) {
            count++;
          }
        }
        return count;
      });

      // Stream for unread group chats
      final groupChatsStream = queryGroupsRecord(
        queryBuilder: (groupsRecord) => groupsRecord.where(
          'userid',
          arrayContains: currentUserReference,
        ),
      ).handleError((error) {
        debugPrint('Error querying group chats for unread count: $error');
        return <GroupsRecord>[];
      }).map((groups) {
        int count = 0;
        for (final group in groups) {
          // Skip placeholder groups
          final name = group.groupName.trim().toLowerCase().replaceAll('!', '');
          if (name == 'say hello') continue;
          
          if (!group.lastmessageseenby.contains(currentUserReference)) {
            count++;
          }
        }
        return count;
      });

      // Combine both streams
      return Rx.combineLatest2<int, int, int>(
        directMessagesStream,
        groupChatsStream,
        (directCount, groupCount) => directCount + groupCount,
      ).handleError((error) {
        debugPrint('Error combining unread count streams: $error');
        return 0;
      });
    } catch (e) {
      debugPrint('Error setting up unread count stream: $e');
      return Stream.value(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DigitalRadicalz',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('de'),
        Locale('fr'),
      ],
      locale: _locale,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      builder: (context, child) => GlobalShimmerWrapper(child: child),
      routerConfig: _router,
    );
  }
}
