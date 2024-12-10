import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../generated/assets.gen.dart';
import '../../common/constants/constants.dart';
import '../../core/locators/locator.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.isHomeScreen = false,
    this.isSuccessScreen = false,
    this.isHistoryScreen = false,
    this.name = '',
  });

  final String name;
  final bool isHomeScreen;
  final bool isSuccessScreen;
  final bool isHistoryScreen;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(_getAppBarHeight());

  double _getAppBarHeight() {
    if (isHomeScreen) {
      return AppConstants.heightAppBarHome;
    } else {
      return AppConstants.heightAppBarMedia;
    }
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: widget.preferredSize.height,
        title: Center(
          child: SizedBox(
            height: widget.preferredSize.height,
            child: _buildTitleContent(),
          ),
        ),
        centerTitle: true,
        actions: _buildActions(),
      ),
    );
  }

  Widget _buildTitleContent() {
    if (widget.isSuccessScreen) {
      return _buildSuccessScreenTitle();
    } else if (widget.isHomeScreen) {
      return _buildHomeScreenTitle();
    } else if (widget.isHistoryScreen) {
      return _buildHistoryScreenTitle();
    } else {
      return _buildDetailScreenTitle();
    }
  }

  Widget _buildSuccessScreenTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Assets.images.logo.image(
                  fit: BoxFit.cover,
                  width: 100,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHomeScreenTitle() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          Text(
            AppConstants.titleHome,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailScreenTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppConstants.titleMedia,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
              ),
            ),
            Column(
              children: [
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(
                    Icons.refresh,
                    size: 32,
                  ),
                  onPressed: () {
                    audioCubit.stopAudio();
                    storageCubit.load("");
                  },
                ),
              ],
            ),
          ],
        ),
        if (widget.name.isNotEmpty)
          Text(
            widget.name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryScreenTitle() {
    return Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Assets.images.logo.image(
              fit: BoxFit.cover,
              width: 100,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions() {
    if (widget.isHistoryScreen) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showPopupMenu(details.globalPosition);
            },
            child: const Icon(Icons.more_vert),
          ),
        ),
      ];
    }
    return [];
  }

  void _showPopupMenu(Offset position) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy + 10, // Điều chỉnh khoảng cách để menu hiển thị bên dưới
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.refresh, color: Colors.blue),
            title: Text("Refresh"),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.delete_sweep, color: Colors.red),
            title: Text("Delete All Histories"),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        _handleMenuSelection(value);
      }
    });
  }

  void _handleMenuSelection(int value) {
    if (value == 1) {
    } else if (value == 2) {}
  }
}
