import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/checkout/checkout_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_cart_model.dart';
export 'my_cart_model.dart';

class MyCartWidget extends StatefulWidget {
const MyCartWidget({super.key});

static String routeName = 'MyCart';
static String routePath = '/myCart';

@override
State<MyCartWidget> createState() => _MyCartWidgetState();
}

class _MyCartWidgetState extends State<MyCartWidget> {
late MyCartModel _model;

final scaffoldKey = GlobalKey<ScaffoldState>();

@override
void initState() {
super.initState();
_model = createModel(context, () => MyCartModel());
}

@override
void dispose() {
_model.dispose();

super.dispose();
}

@override
Widget build(BuildContext context) {
context.watch<FFAppState>();

return Scaffold(
key: scaffoldKey,
backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
appBar: AppBar(
backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
automaticallyImplyLeading: false,
leading: FlutterFlowIconButton(
borderColor: Colors.transparent,
borderRadius: 30.0,
borderWidth: 1.0,
buttonSize: 60.0,
icon: Icon(
Icons.arrow_back_rounded,
color: FlutterFlowTheme.of(context).primaryText,
size: 30.0,
),
onPressed: () async {
context.pop();
},
),
title: Text(
'My Cart',
style: FlutterFlowTheme.of(context).headlineMedium.override(
font: GoogleFonts.interTight(
fontWeight:
FlutterFlowTheme.of(context).headlineMedium.fontWeight,
fontStyle:
FlutterFlowTheme.of(context).headlineMedium.fontStyle,
),
color: FlutterFlowTheme.of(context).primaryText,
fontSize: 22.0,
letterSpacing: 0.0,
fontWeight:
FlutterFlowTheme.of(context).headlineMedium.fontWeight,
fontStyle:
FlutterFlowTheme.of(context).headlineMedium.fontStyle,
),
),
actions: [],
centerTitle: true,
elevation: 2.0,
),
body: SafeArea(
top: true,
child: !loggedIn
? Center(
child: Padding(
padding: EdgeInsets.all(24.0),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.lock_outline,
size: 56.0,
color: FlutterFlowTheme.of(context).secondaryText,
),
SizedBox(height: 12.0),
Text(
'Please log in to view your cart.',
textAlign: TextAlign.center,
style: FlutterFlowTheme.of(context).bodyMedium.override(
letterSpacing: 0.0,
),
),
SizedBox(height: 16.0),
FFButtonWidget(
onPressed: () async {
context.pushNamed(LoginWidget.routeName);
},
text: 'Go to Login',
options: FFButtonOptions(
height: 44.0,
padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
color: FlutterFlowTheme.of(context).primary,
textStyle: FlutterFlowTheme.of(context).titleSmall.override(
font: GoogleFonts.interTight(
fontWeight: FontWeight.w500,
fontStyle:
FlutterFlowTheme.of(context).titleSmall.fontStyle,
),
color: Colors.white,
letterSpacing: 0.0,
fontWeight: FontWeight.w500,
fontStyle:
FlutterFlowTheme.of(context).titleSmall.fontStyle,
),
elevation: 0.0,
borderRadius: BorderRadius.circular(12.0),
),
),
],
),
),
)
: StreamBuilder<List<ProductidRecord>>(
stream: queryProductidRecord(
queryBuilder: (productidRecord) => productidRecord
.where('userid', isEqualTo: currentUserReference),
),
builder: (context, snapshot) {
// Handle errors
if (snapshot.hasError) {
debugPrint('Error loading cart: ${snapshot.error}');
return Stack(
alignment: AlignmentDirectional(0.0, -1.0),
children: [
Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.error_outline,
size: 80,
color: Colors.grey[400],
),
SizedBox(height: 16),
Text(
'Unable to load cart',
style: FlutterFlowTheme.of(context).headlineSmall.override(
color: Colors.grey[600],
letterSpacing: 0.0,
),
),
SizedBox(height: 8),
Text(
'Please check your connection',
style: FlutterFlowTheme.of(context).bodyMedium.override(
color: Colors.grey[500],
letterSpacing: 0.0,
),
),
],
),
),
Align(
alignment: AlignmentDirectional(0.0, 1.0),
child: Container(
width: 364.0,
height: 67.0,
decoration: BoxDecoration(
color: Colors.grey[300],
borderRadius: BorderRadius.circular(20.0),
),
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Error Loading Cart',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w600,
),
color: Colors.grey[600],
fontSize: 18.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w600,
),
),
],
),
),
),
],
);
}

// Customize what your widget looks like when it's loading.
if (!snapshot.hasData) {
return Stack(
alignment: AlignmentDirectional(0.0, -1.0),
children: [
Center(
child: SizedBox(
width: 50.0,
height: 50.0,
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(
FlutterFlowTheme.of(context).primary,
),
),
),
),
Align(
alignment: AlignmentDirectional(0.0, 1.0),
child: Container(
width: 364.0,
height: 67.0,
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).primary,
borderRadius: BorderRadius.circular(20.0),
),
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Loading...',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w600,
fontStyle: FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
color: FlutterFlowTheme.of(context)
.secondaryBackground,
fontSize: 18.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w600,
fontStyle: FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
),
],
),
),
),
],
);
}

List<ProductidRecord> columnProductidRecordList = snapshot.data!;

// Filter out items with null productid
List<ProductidRecord> validCartItems = columnProductidRecordList
.where((item) => item.productid != null)
.toList();

// Compute total dynamically from valid cart items
double cartTotal = validCartItems.fold(0.0, (sum, item) => sum + item.price);

// Group identical items by product reference to show unique rows
final Map<DocumentReference, Map<String, dynamic>> grouped = {};
for (final item in validCartItems) {
final key = item.productid!;
if (!grouped.containsKey(key)) {
grouped[key] = {
'quantity': 1,
'totalPrice': item.price,
'unitPrice': item.price,
'cartEntryRefs': <DocumentReference>[
item.reference,
],
};
} else {
grouped[key]![
'quantity'
] = (grouped[key]!['quantity'] as int) + 1;
grouped[key]![
'totalPrice'
] = (grouped[key]!['totalPrice'] as double) + item.price;
(grouped[key]!['cartEntryRefs'] as List<DocumentReference>).add(item.reference);
}
}
final groupedEntries = grouped.entries.toList();

// Show empty cart message if no valid items
if (validCartItems.isEmpty) {
return Stack(
alignment: AlignmentDirectional(0.0, -1.0),
children: [
Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.shopping_cart_outlined,
size: 80,
color: Colors.grey[400],
),
SizedBox(height: 16),
Text(
'Your cart is empty',
style: FlutterFlowTheme.of(context).headlineSmall.override(
color: Colors.grey[600],
letterSpacing: 0.0,
),
),
SizedBox(height: 8),
Text(
'Add some products to get started',
style: FlutterFlowTheme.of(context).bodyMedium.override(
color: Colors.grey[500],
letterSpacing: 0.0,
),
),
],
),
),
Align(
alignment: AlignmentDirectional(0.0, 1.0),
child: Container(
width: 364.0,
height: 67.0,
decoration: BoxDecoration(
color: Colors.grey[300],
borderRadius: BorderRadius.circular(20.0),
),
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Cart Empty',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w600,
),
color: Colors.grey[600],
fontSize: 18.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w600,
),
),
],
),
),
),
],
);
}

return Stack(
alignment: AlignmentDirectional(0.0, -1.0),
children: [
SingleChildScrollView(
child: Column(
mainAxisSize: MainAxisSize.max,
children: List.generate(groupedEntries.length, (index) {
final entry = groupedEntries[index];
final productRef = entry.key;
final quantity = entry.value['quantity'] as int;
final totalPrice = entry.value['totalPrice'] as double;
final unitPrice = entry.value['unitPrice'] as double;
final cartEntryRefs = (entry.value['cartEntryRefs'] as List<DocumentReference>);

return Padding(
padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
child: Column(
mainAxisSize: MainAxisSize.max,
children: [
Padding(
padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
child: InkWell(
splashColor: Colors.transparent,
focusColor: Colors.transparent,
hoverColor: Colors.transparent,
highlightColor: Colors.transparent,
onTap: () async {
context.pushNamed(
ProductDetailWidget.routeName,
queryParameters: {
'productref': serializeParam(
productRef,
ParamType.DocumentReference,
),
}.withoutNulls,
);
},
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
Row(
mainAxisSize: MainAxisSize.max,
children: [
Column(
mainAxisSize: MainAxisSize.max,
children: [
Padding(
padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
child: StreamBuilder<ProductRecord>(
stream: ProductRecord.getDocument(productRef),
builder: (context, snapshot) {
if (snapshot.hasError) {
debugPrint('Error loading product: ${snapshot.error}');
return Container(
width: 70.0,
height: 64.0,
decoration: BoxDecoration(
color: Colors.grey[200],
borderRadius: BorderRadius.circular(8.0),
),
child: Icon(
Icons.error_outline,
color: Colors.grey[400],
size: 30,
),
);
}

if (!snapshot.hasData) {
return Center(
child: SizedBox(
width: 50.0,
height: 50.0,
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(
FlutterFlowTheme.of(context).primary,
),
),
),
);
}

final containerProductRecord = snapshot.data!;

return Stack(
clipBehavior: Clip.none,
children: [
Container(
width: 70.0,
height: 64.0,
decoration: BoxDecoration(
color: Colors.grey[200],
image: (containerProductRecord.image.isNotEmpty)
? DecorationImage(
fit: BoxFit.cover,
image: NetworkImage(
containerProductRecord.image,
),
)
: null,
borderRadius: BorderRadius.circular(8.0),
),
child: (containerProductRecord.image.isEmpty)
? Icon(
Icons.image,
color: Colors.grey[400],
size: 30,
)
: null,
),
if (quantity > 1)
Positioned(
right: -6,
top: -6,
child: Container(
padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).primary,
borderRadius: BorderRadius.circular(10),
),
child: Text(
'x$quantity',
style: FlutterFlowTheme.of(context).bodySmall.override(
color: FlutterFlowTheme.of(context).secondaryBackground,
fontWeight: FontWeight.w600,
letterSpacing: 0.0,
),
),
),
),
],
);
},
),
),
],
),
Column(
mainAxisSize: MainAxisSize.max,
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisSize: MainAxisSize.max,
children: [
StreamBuilder<ProductRecord>(
stream: ProductRecord.getDocument(productRef),
builder: (context, snapshot) {
if (snapshot.hasError) {
debugPrint('Error loading product name: ${snapshot.error}');
return Text(
'Product unavailable',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w500,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
color: Colors.grey[400],
fontSize: 16.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w500,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
);
}

if (!snapshot.hasData) {
return Center(
child: SizedBox(
width: 50.0,
height: 50.0,
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(
FlutterFlowTheme.of(context).primary,
),
),
),
);
}

final textProductRecord = snapshot.data!;

return Row(
children: [
Text(
textProductRecord.name ?? 'Unknown Product',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w500,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
fontSize: 16.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w500,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
),
if (quantity > 1)
Padding(
padding: EdgeInsetsDirectional.only(start: 8.0),
child: Container(
padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).alternate,
borderRadius: BorderRadius.circular(12),
),
child: Text(
'$quantity items',
style: FlutterFlowTheme.of(context).bodySmall.override(
color: FlutterFlowTheme.of(context).primaryText,
letterSpacing: 0.0,
),
),
),
),
],
);
},
),
],
),
Row(
mainAxisSize: MainAxisSize.max,
children: [
StreamBuilder<ProductRecord>(
stream: ProductRecord.getDocument(productRef),
builder: (context, snapshot) {
if (snapshot.hasError) {
debugPrint('Error loading product details: ${snapshot.error}');
return Text(
'N/A',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.normal,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
color: Colors.grey[400],
fontSize: 14.0,
letterSpacing: 0.0,
fontWeight: FontWeight.normal,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
);
}

if (!snapshot.hasData) {
return Center(
child: SizedBox(
width: 50.0,
height: 50.0,
child: CircularProgressIndicator(
valueColor: AlwaysStoppedAnimation<Color>(
FlutterFlowTheme.of(context).primary,
),
),
),
);
}

final textProductRecord = snapshot.data!;

return Text(
textProductRecord.sizecapacity ?? 'N/A',
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.normal,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
color: FlutterFlowTheme.of(context).secondaryText,
fontSize: 14.0,
letterSpacing: 0.0,
fontWeight: FontWeight.normal,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
);
},
),
],
),
],
),
],
),
Container(
height: 75.0,
decoration: BoxDecoration(),
child: Padding(
padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
child: Column(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
InkWell(
splashColor: Colors.transparent,
focusColor: Colors.transparent,
hoverColor: Colors.transparent,
highlightColor: Colors.transparent,
onTap: () async {
// Remove all entries of this product from the cart
for (final ref in cartEntryRefs) {
await ref.delete();
}
},
child: Icon(
Icons.remove_shopping_cart_outlined,
color: FlutterFlowTheme.of(context).secondaryText,
size: 24.0,
),
),
Column(
children: [
Text(
formatNumber(
totalPrice,
formatType: FormatType.decimal,
decimalType: DecimalType.periodDecimal,
currency: r'$',
),
style: FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w500,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
fontSize: 16.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w500,
fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
),
),
if (quantity > 1)
Text(
'(' + formatNumber(unitPrice, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal, currency: '\$') + ' ea)',
style: FlutterFlowTheme.of(context).bodySmall.override(
color: FlutterFlowTheme.of(context).secondaryText,
letterSpacing: 0.0,
),
),
],
),
],
),
),
),
],
),
),
),
],
),
);
}),
),
),
Align(
alignment: AlignmentDirectional(0.0, 1.0),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
// Continue Shopping button (white)
Container(
width: 364.0,
height: 67.0,
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20.0),
border: Border.all(
color: FlutterFlowTheme.of(context).alternate,
width: 1.0,
),
),
child: InkWell(
splashColor: Colors.transparent,
focusColor: Colors.transparent,
hoverColor: Colors.transparent,
highlightColor: Colors.transparent,
onTap: () async {
context.pushNamed(ShopWidget.routeName);
},
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Continue Shopping',
style: FlutterFlowTheme.of(context)
.bodyMedium
.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w600,
fontStyle: FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
color: FlutterFlowTheme.of(context)
.primaryText,
fontSize: 18.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w600,
fontStyle: FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
),
],
),
),
),
SizedBox(height: 12.0),
// Go to Checkout button (existing)
Container(
width: 364.0,
height: 67.0,
decoration: BoxDecoration(
color: FlutterFlowTheme.of(context).primary,
borderRadius: BorderRadius.circular(20.0),
),
child: InkWell(
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
return Padding(
padding: MediaQuery.viewInsetsOf(context),
child: Container(
height:
MediaQuery.sizeOf(context).height * 0.74,
child: CheckoutWidget(
cartTotal: cartTotal,
),
),
);
},
).then((value) => safeSetState(() {}));
},
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
'Go to Checkout',
style:
FlutterFlowTheme.of(context).bodyMedium.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w600,
fontStyle: FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
color: FlutterFlowTheme.of(context)
.secondaryBackground,
fontSize: 18.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w600,
fontStyle: FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
),
Padding(
padding: EdgeInsetsDirectional.fromSTEB(
12.0, 0.0, 0.0, 0.0),
child: Container(
height: 22.0,
decoration: BoxDecoration(
color: Color(0xFF308596),
borderRadius: BorderRadius.circular(8.0),
),
child: Padding(
padding: EdgeInsetsDirectional.fromSTEB(
8.0, 0.0, 8.0, 0.0),
child: Row(
mainAxisSize: MainAxisSize.max,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
String.fromCharCode(36) + formatNumber(
cartTotal,
formatType: FormatType.decimal,
decimalType: DecimalType.periodDecimal,
),
style: FlutterFlowTheme.of(context)
.bodyMedium
.override(
font: GoogleFonts.inter(
fontWeight: FontWeight.w600,
fontStyle:
FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
color: FlutterFlowTheme.of(context)
.alternate,
fontSize: 10.0,
letterSpacing: 0.0,
fontWeight: FontWeight.w600,
fontStyle:
FlutterFlowTheme.of(context)
.bodyMedium
.fontStyle,
),
),
],
),
),
),
),
],
),
),
),
],
),
),
],
);
},
),
),
);
}
}
