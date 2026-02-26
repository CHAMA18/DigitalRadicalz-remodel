import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewMembersBottomSheet extends StatefulWidget {
  const ViewMembersBottomSheet({
    required this.groupRecord,
  });

  final GroupsRecord groupRecord;

  @override
  State<ViewMembersBottomSheet> createState() => _ViewMembersBottomSheetState();
}

class _ViewMembersBottomSheetState extends State<ViewMembersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _displayNameForUser(UsersRecord user) {
    if (user.displayName.isNotEmpty) return user.displayName;
    if (user.email.isNotEmpty) return user.email;
    return 'User';
  }

  List<UsersRecord> _filterUsers(List<UsersRecord> users) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      final name = user.displayName.toLowerCase();
      final email = user.email.toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  bool _isUserAdmin(GroupsRecord groupRecord, DocumentReference userRef) {
    if (groupRecord.adminId == userRef) return true;
    if (groupRecord.adminIds.contains(userRef)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UsersRecord>>(
      stream: queryUsersRecord(
        queryBuilder: (usersRecord) =>
            usersRecord.orderBy('display_name', descending: false),
      ),
      builder: (context, usersSnapshot) {
        if (!usersSnapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
              ),
            ),
            child: Center(
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
          );
        }

        final allUsers = usersSnapshot.data!;
        final members = allUsers
            .where((user) => widget.groupRecord.userid.contains(user.reference))
            .toList();
        final usersToShow = _filterUsers(members);

        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 40.0), // Spacer for centering title
                    Text(
                      'Group Members',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    FlutterFlowIconButton(
                      borderRadius: 8.0,
                      buttonSize: 40.0,
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search members...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                  ),
                ),
                SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${members.length} members',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodySmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: usersToShow.isEmpty
                      ? Center(
                          child: Text(
                            'No members found.',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: usersToShow.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1.0,
                            color: FlutterFlowTheme.of(context).alternate,
                          ),
                          itemBuilder: (context, index) {
                            final user = usersToShow[index];
                            final isAdmin = _isUserAdmin(widget.groupRecord, user.reference);
                            final isCreator = widget.groupRecord.adminId == user.reference;
                            
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                width: 42.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  image: user.photoUrl.isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.network(user.photoUrl).image,
                                        )
                                      : null,
                                  shape: BoxShape.circle,
                                ),
                                child: user.photoUrl.isEmpty
                                    ? Icon(
                                        Icons.person_outline,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 22.0,
                                      )
                                    : null,
                              ),
                              title: Text(
                                _displayNameForUser(user),
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              subtitle: isAdmin || isCreator
                                  ? Text(
                                      isCreator ? 'Creator' : 'Admin',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context).primary,
                                            letterSpacing: 0.0,
                                          ),
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}