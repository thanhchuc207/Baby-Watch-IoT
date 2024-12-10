import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final String? urlImage;
  final IconData? icon;
  final String text;
  final VoidCallback onPressed;

  const ButtonLogin(
      {super.key,
      this.urlImage,
      this.icon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
      child: OutlinedButton(
        onPressed: () {
          onPressed();
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          side: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 30,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(width: 20),
              ] else if (urlImage != null) ...[
                Image.asset(
                  urlImage!,
                  fit: BoxFit.cover,
                  height: 30.0,
                  width: 30.0,
                ),
                const SizedBox(width: 20),
              ],
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
