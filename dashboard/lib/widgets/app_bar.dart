// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'sign_in_button.dart';

/// Cocoon-specific variant of the [AppBar] widget.
///
/// The [actions] will always have a [SignInButton] added.
class CocoonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CocoonAppBar({super.key, this.title, this.actions, this.backgroundColor});

  final Widget? title;

  final List<Widget>? actions;

  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
      actions: <Widget>[
        ...?actions,
        if (actions != null && actions!.isNotEmpty) const SizedBox(width: 8),
        SignInButton(
          colorBrightness: theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
        ),
      ],
    );
  }
}
