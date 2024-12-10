import 'package:flutter/material.dart';

class CustomButtonInPageUser extends StatelessWidget {
  final IconData icon;
  final Color? circleColor;
  final String initialText;
  final String? subText;
  final VoidCallback? onPressed;
  final bool enableTrailing;

  const CustomButtonInPageUser({
    super.key,
    required this.icon,
    required this.initialText,
    this.subText,
    this.onPressed,
    this.circleColor = Colors.transparent,
    this.enableTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            splashColor:
                Theme.of(context).colorScheme.surface, // Loại bỏ splash
            highlightColor: Theme.of(context)
                .colorScheme
                .surface, // Loại bỏ hiệu ứng highlight
            onTap: onPressed,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: circleColor, // Màu nền của hình tròn
                child: Icon(icon,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface), // Icon màu trắng
              ),
              title: Text(
                initialText,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: subText != null
                  ? Text(
                      subText!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    )
                  : null,
              trailing: enableTrailing ? Icon(Icons.chevron_right) : null,
            ),
          ),
        ),
      ],
    );
  }
}
