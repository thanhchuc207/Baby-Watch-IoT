import 'package:flutter/material.dart';

class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.title});

  final IconData icon;
  final Color iconColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1), // Màu nền nhạt hơn
        child: Icon(icon, color: iconColor), // Icon với màu sắc
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Xử lý sự kiện khi tap vào item
      },
    );
  }
}
