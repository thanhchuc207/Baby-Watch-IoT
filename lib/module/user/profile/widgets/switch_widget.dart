import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const SwitchWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent, // Màu nền của hình tròn
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            title: Text(title), // Sử dụng `title` truyền vào
            trailing: Switch(
              value: value, // Sử dụng `value` truyền vào
              onChanged: onChanged, // Sử dụng `onChanged` truyền vào
              activeColor: Theme.of(context).colorScheme.secondaryFixed,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }
}
