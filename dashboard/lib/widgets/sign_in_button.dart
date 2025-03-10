// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:provider/provider.dart';

import '../service/google_authentication.dart';

enum _SignInButtonAction { logout }

/// Widget for displaying sign in information for the current user.
///
/// If logged in, it will display the user's avatar. Clicking it opens a dropdown for logging out.
/// Otherwise, a sign in button will show.
class SignInButton extends StatelessWidget {
  const SignInButton({
    super.key,
    this.colorBrightness,
  });

  final Brightness? colorBrightness;

  @override
  Widget build(BuildContext context) {
    final GoogleSignInService authService = Provider.of<GoogleSignInService>(context);
    final Color textButtonForeground =
        (colorBrightness ?? Theme.of(context).brightness) == Brightness.dark ? Colors.white : Colors.black87;

    return FutureBuilder<bool>(
      future: authService.isAuthenticated,
      builder: (BuildContext context, AsyncSnapshot<bool> isAuthenticated) {
        /// On sign out, there's a second where the user is null before isAuthenticated catches up.
        if (isAuthenticated.data == true && authService.user != null) {
          return PopupMenuButton<_SignInButtonAction>(
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<_SignInButtonAction>>[
              const PopupMenuItem<_SignInButtonAction>(
                value: _SignInButtonAction.logout,
                child: Text('Log out'),
              ),
            ],
            onSelected: (_SignInButtonAction value) {
              switch (value) {
                case _SignInButtonAction.logout:
                  authService.signOut();
                  break;
              }
            },
            iconSize: Scaffold.of(context).appBarMaxHeight,
            icon: Builder(
              builder: (BuildContext context) {
                if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 20.0),
                    child: Text(authService.user!.email),
                  );
                }
                return GoogleUserCircleAvatar(
                  identity: authService.user!,
                );
              },
            ),
          );
        }
        return TextButton(
          style: TextButton.styleFrom(foregroundColor: textButtonForeground),
          onPressed: authService.signIn,
          child: const Text('SIGN IN'),
        );
      },
    );
  }
}
