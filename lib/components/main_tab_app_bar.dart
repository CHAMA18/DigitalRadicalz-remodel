import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/profile/profile_widget.dart';
import '/components/unread_message_badge.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';

class MainTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainTabAppBar({
    super.key,
    this.showShopActions = false,
  });

  final bool showShopActions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                width: 150.0,
                height: 44.0,
                child: Image.asset(
                  'assets/images/Digital_radicalz_(1).png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showShopActions) _buildCartAction(context),
              if (showShopActions)
                FlutterFlowIconButton(
                  borderRadius: 8.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.favorite_border,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(FavoriteWidget.routeName);
                  },
                ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: UnreadMessageBadge(
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
                              child: ProfileWidget(),
                            ),
                          ),
                        );
                      },
                    );
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
      elevation: 2.0,
    );
  }

  Widget _buildCartAction(BuildContext context) {
    if (!loggedIn || currentUserReference == null) {
      return FlutterFlowIconButton(
        borderRadius: 8.0,
        buttonSize: 40.0,
        icon: Icon(
          Icons.shopping_cart_outlined,
          color: FlutterFlowTheme.of(context).primaryText,
          size: 24.0,
        ),
        onPressed: () async {
          context.pushNamed(MyCartWidget.routeName);
        },
      );
    }

    return StreamBuilder<List<ProductidRecord>>(
      stream: queryProductidRecord(
        queryBuilder: (r) => r.where('userid', isEqualTo: currentUserReference),
      ),
      builder: (context, snapshot) {
        final count = (snapshot.data ?? [])
            .where((item) => item.productid != null)
            .length;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            FlutterFlowIconButton(
              borderRadius: 8.0,
              buttonSize: 40.0,
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed(MyCartWidget.routeName);
              },
            ),
            Positioned(
              right: 0,
              top: -2,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInBack,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: count > 0
                    ? Container(
                        key: ValueKey<int>(count),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Center(
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey<String>('empty'),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
