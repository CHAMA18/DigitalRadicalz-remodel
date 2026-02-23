import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _Interestslists = prefs
              .getStringList('ff_Interestslists')
              ?.map((path) => path.ref)
              .toList() ??
          _Interestslists;
    });
    _safeInit(() {
      _Listoffavorites = prefs
              .getStringList('ff_Listoffavorites')
              ?.map((path) => path.ref)
              .toList() ??
          _Listoffavorites;
    });
    _safeInit(() {
      _listofcart = prefs
              .getStringList('ff_listofcart')
              ?.map((path) => path.ref)
              .toList() ??
          _listofcart;
    });
    _safeInit(() {
      _quantyi = prefs.getInt('ff_quantyi') ?? _quantyi;
    });
    _safeInit(() {
      _listofalreadytextedusers = prefs
              .getStringList('ff_listofalreadytextedusers')
              ?.map((path) => path.ref)
              .toList() ??
          _listofalreadytextedusers;
    });
    _safeInit(() {
      _useSystemLocale = prefs.getBool('ff_useSystemLocale') ?? _useSystemLocale;
    });
    _safeInit(() {
      _appLocaleCode = prefs.getString('ff_appLocaleCode') ?? _appLocaleCode;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  // Global UI shimmer toggle for skeleton loading
  bool _shimmerEnabled = false;
  bool get shimmerEnabled => _shimmerEnabled;
  set shimmerEnabled(bool value) {
    if (_shimmerEnabled == value) return;
    _shimmerEnabled = value;
    notifyListeners();
  }

  String _onpage = 'Home';
  String get onpage => _onpage;
  set onpage(String value) {
    _onpage = value;
  }

  String _chatTab = 'Berichten';
  String get chatTab => _chatTab;
  set chatTab(String value) {
    _chatTab = value;
  }

  String _tickettypename = '';
  String get tickettypename => _tickettypename;
  set tickettypename(String value) {
    _tickettypename = value;
  }

  double _Tickettypeprice = 0.0;
  double get Tickettypeprice => _Tickettypeprice;
  set Tickettypeprice(double value) {
    _Tickettypeprice = value;
  }

  int _tickettypequantity = 0;
  int get tickettypequantity => _tickettypequantity;
  set tickettypequantity(int value) {
    _tickettypequantity = value;
  }

  int _tickettotal = 0;
  int get tickettotal => _tickettotal;
  set tickettotal(int value) {
    _tickettotal = value;
  }

  String _username = '';
  String get username => _username;
  set username(String value) {
    _username = value;
  }

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
  }

  // Internationalization settings
  bool _useSystemLocale = true;
  bool get useSystemLocale => _useSystemLocale;
  set useSystemLocale(bool value) {
    _useSystemLocale = value;
    prefs.setBool('ff_useSystemLocale', value);
  }

  String _appLocaleCode = 'en';
  String get appLocaleCode => _appLocaleCode;
  set appLocaleCode(String value) {
    _appLocaleCode = value;
    prefs.setString('ff_appLocaleCode', value);
  }

  List<DocumentReference> _Interestslists = [];
  List<DocumentReference> get Interestslists => _Interestslists;
  set Interestslists(List<DocumentReference> value) {
    _Interestslists = value;
    prefs.setStringList('ff_Interestslists', value.map((x) => x.path).toList());
  }

  void addToInterestslists(DocumentReference value) {
    Interestslists.add(value);
    prefs.setStringList(
        'ff_Interestslists', _Interestslists.map((x) => x.path).toList());
  }

  void removeFromInterestslists(DocumentReference value) {
    Interestslists.remove(value);
    prefs.setStringList(
        'ff_Interestslists', _Interestslists.map((x) => x.path).toList());
  }

  void removeAtIndexFromInterestslists(int index) {
    Interestslists.removeAt(index);
    prefs.setStringList(
        'ff_Interestslists', _Interestslists.map((x) => x.path).toList());
  }

  void updateInterestslistsAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    Interestslists[index] = updateFn(_Interestslists[index]);
    prefs.setStringList(
        'ff_Interestslists', _Interestslists.map((x) => x.path).toList());
  }

  void insertAtIndexInInterestslists(int index, DocumentReference value) {
    Interestslists.insert(index, value);
    prefs.setStringList(
        'ff_Interestslists', _Interestslists.map((x) => x.path).toList());
  }

  List<DocumentReference> _Listoffavorites = [];
  List<DocumentReference> get Listoffavorites => _Listoffavorites;
  set Listoffavorites(List<DocumentReference> value) {
    _Listoffavorites = value;
    prefs.setStringList(
        'ff_Listoffavorites', value.map((x) => x.path).toList());
  }

  void addToListoffavorites(DocumentReference value) {
    Listoffavorites.add(value);
    prefs.setStringList(
        'ff_Listoffavorites', _Listoffavorites.map((x) => x.path).toList());
  }

  void removeFromListoffavorites(DocumentReference value) {
    Listoffavorites.remove(value);
    prefs.setStringList(
        'ff_Listoffavorites', _Listoffavorites.map((x) => x.path).toList());
  }

  void removeAtIndexFromListoffavorites(int index) {
    Listoffavorites.removeAt(index);
    prefs.setStringList(
        'ff_Listoffavorites', _Listoffavorites.map((x) => x.path).toList());
  }

  void updateListoffavoritesAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    Listoffavorites[index] = updateFn(_Listoffavorites[index]);
    prefs.setStringList(
        'ff_Listoffavorites', _Listoffavorites.map((x) => x.path).toList());
  }

  void insertAtIndexInListoffavorites(int index, DocumentReference value) {
    Listoffavorites.insert(index, value);
    prefs.setStringList(
        'ff_Listoffavorites', _Listoffavorites.map((x) => x.path).toList());
  }

  List<DocumentReference> _listofcart = [];
  List<DocumentReference> get listofcart => _listofcart;
  set listofcart(List<DocumentReference> value) {
    _listofcart = value;
    prefs.setStringList('ff_listofcart', value.map((x) => x.path).toList());
  }

  void addToListofcart(DocumentReference value) {
    listofcart.add(value);
    prefs.setStringList(
        'ff_listofcart', _listofcart.map((x) => x.path).toList());
  }

  void removeFromListofcart(DocumentReference value) {
    listofcart.remove(value);
    prefs.setStringList(
        'ff_listofcart', _listofcart.map((x) => x.path).toList());
  }

  void removeAtIndexFromListofcart(int index) {
    listofcart.removeAt(index);
    prefs.setStringList(
        'ff_listofcart', _listofcart.map((x) => x.path).toList());
  }

  void updateListofcartAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    listofcart[index] = updateFn(_listofcart[index]);
    prefs.setStringList(
        'ff_listofcart', _listofcart.map((x) => x.path).toList());
  }

  void insertAtIndexInListofcart(int index, DocumentReference value) {
    listofcart.insert(index, value);
    prefs.setStringList(
        'ff_listofcart', _listofcart.map((x) => x.path).toList());
  }

  double _Carttotal = 0.0;
  double get Carttotal => _Carttotal;
  set Carttotal(double value) {
    _Carttotal = value;
  }

  int _quantyi = 0;
  int get quantyi => _quantyi;
  set quantyi(int value) {
    _quantyi = value;
    prefs.setInt('ff_quantyi', value);
  }

  double _Carttotalprice = 0.0;
  double get Carttotalprice => _Carttotalprice;
  set Carttotalprice(double value) {
    _Carttotalprice = value;
  }

  int _TickettypeQuantity = 0;
  int get TickettypeQuantity => _TickettypeQuantity;
  set TickettypeQuantity(int value) {
    _TickettypeQuantity = value;
  }

  List<DocumentReference> _listofalreadytextedusers = [];
  List<DocumentReference> get listofalreadytextedusers =>
      _listofalreadytextedusers;
  set listofalreadytextedusers(List<DocumentReference> value) {
    _listofalreadytextedusers = value;
    prefs.setStringList(
        'ff_listofalreadytextedusers', value.map((x) => x.path).toList());
  }

  void addToListofalreadytextedusers(DocumentReference value) {
    listofalreadytextedusers.add(value);
    prefs.setStringList('ff_listofalreadytextedusers',
        _listofalreadytextedusers.map((x) => x.path).toList());
  }

  void removeFromListofalreadytextedusers(DocumentReference value) {
    listofalreadytextedusers.remove(value);
    prefs.setStringList('ff_listofalreadytextedusers',
        _listofalreadytextedusers.map((x) => x.path).toList());
  }

  void removeAtIndexFromListofalreadytextedusers(int index) {
    listofalreadytextedusers.removeAt(index);
    prefs.setStringList('ff_listofalreadytextedusers',
        _listofalreadytextedusers.map((x) => x.path).toList());
  }

  void updateListofalreadytextedusersAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    listofalreadytextedusers[index] =
        updateFn(_listofalreadytextedusers[index]);
    prefs.setStringList('ff_listofalreadytextedusers',
        _listofalreadytextedusers.map((x) => x.path).toList());
  }

  void insertAtIndexInListofalreadytextedusers(
      int index, DocumentReference value) {
    listofalreadytextedusers.insert(index, value);
    prefs.setStringList('ff_listofalreadytextedusers',
        _listofalreadytextedusers.map((x) => x.path).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
