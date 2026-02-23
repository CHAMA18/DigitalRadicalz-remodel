// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectedTicketsStruct extends FFFirebaseStruct {
  SelectedTicketsStruct({
    String? tickettypes,
    int? quantities,
    double? price,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _tickettypes = tickettypes,
        _quantities = quantities,
        _price = price,
        super(firestoreUtilData);

  // "tickettypes" field.
  String? _tickettypes;
  String get tickettypes => _tickettypes ?? '';
  set tickettypes(String? val) => _tickettypes = val;

  bool hasTickettypes() => _tickettypes != null;

  // "quantities" field.
  int? _quantities;
  int get quantities => _quantities ?? 0;
  set quantities(int? val) => _quantities = val;

  void incrementQuantities(int amount) => quantities = quantities + amount;

  bool hasQuantities() => _quantities != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  static SelectedTicketsStruct fromMap(Map<String, dynamic> data) =>
      SelectedTicketsStruct(
        tickettypes: data['tickettypes'] as String?,
        quantities: castToType<int>(data['quantities']),
        price: castToType<double>(data['price']),
      );

  static SelectedTicketsStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectedTicketsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'tickettypes': _tickettypes,
        'quantities': _quantities,
        'price': _price,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'tickettypes': serializeParam(
          _tickettypes,
          ParamType.String,
        ),
        'quantities': serializeParam(
          _quantities,
          ParamType.int,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
      }.withoutNulls;

  static SelectedTicketsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectedTicketsStruct(
        tickettypes: deserializeParam(
          data['tickettypes'],
          ParamType.String,
          false,
        ),
        quantities: deserializeParam(
          data['quantities'],
          ParamType.int,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'SelectedTicketsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectedTicketsStruct &&
        tickettypes == other.tickettypes &&
        quantities == other.quantities &&
        price == other.price;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([tickettypes, quantities, price]);
}

SelectedTicketsStruct createSelectedTicketsStruct({
  String? tickettypes,
  int? quantities,
  double? price,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SelectedTicketsStruct(
      tickettypes: tickettypes,
      quantities: quantities,
      price: price,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SelectedTicketsStruct? updateSelectedTicketsStruct(
  SelectedTicketsStruct? selectedTickets, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    selectedTickets
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSelectedTicketsStructData(
  Map<String, dynamic> firestoreData,
  SelectedTicketsStruct? selectedTickets,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (selectedTickets == null) {
    return;
  }
  if (selectedTickets.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && selectedTickets.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final selectedTicketsData =
      getSelectedTicketsFirestoreData(selectedTickets, forFieldValue);
  final nestedData =
      selectedTicketsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = selectedTickets.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSelectedTicketsFirestoreData(
  SelectedTicketsStruct? selectedTickets, [
  bool forFieldValue = false,
]) {
  if (selectedTickets == null) {
    return {};
  }
  final firestoreData = mapToFirestore(selectedTickets.toMap());

  // Add any Firestore field values
  selectedTickets.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSelectedTicketsListFirestoreData(
  List<SelectedTicketsStruct>? selectedTicketss,
) =>
    selectedTicketss
        ?.map((e) => getSelectedTicketsFirestoreData(e, true))
        .toList() ??
    [];
