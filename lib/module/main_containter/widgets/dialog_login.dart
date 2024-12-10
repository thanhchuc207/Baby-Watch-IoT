import 'dart:io';
import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';
import 'button_login.dart';

class DialogBoxLogin {
  static Future displayDialogBox(BuildContext context) async {
    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return null;
    } else {
      await showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // logo
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 3.0,
                      ),
                    ),
                    child: Assets.images.logo.image(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // content
                const Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: Text(
                    'Edu Smart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (Platform.isIOS)
                  ButtonLogin(
                    icon: Icons.apple,
                    text: 'Sign in with Apple',
                    onPressed: () {
                      // Add your Apple sign-in logic here
                    },
                  ),

                // button for Google sign in
                ButtonLogin(
                  urlImage: Assets.images.google.path,
                  text: 'Sign in with Google',
                  onPressed: () {
                    //context.router.push(const SignInGoogleRoute());
                  },
                ),

                // button for email sign in
                ButtonLogin(
                  icon: Icons.email,
                  text: 'Sign in with email',
                  onPressed: () {},
                ),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      );
    }
  }
}
