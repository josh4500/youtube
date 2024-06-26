// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:flutter/material.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class AccountOptionTile extends StatelessWidget {
  const AccountOptionTile({
    super.key,
    required this.title,
    required this.icon,
    this.networkRequired = false,
    this.summary,
    this.onTap,
  });
  final String title;
  final IconData icon;
  final String? summary;
  final bool networkRequired;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // TODO(josh4500): Use TappableArea
    if (networkRequired) {
      return NetworkListenableBuilder(
        builder: (BuildContext context, ConnectivityState state) {
          return ListTile(
            leading: Icon(icon),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            selectedColor: Colors.white,
            selectedTileColor: Colors.grey,
            title: Text(title),
            subtitle: summary != null
                ? Text(
                    summary!,
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                    ),
                  )
                : null,
            onTap: onTap,
            enabled: state.isConnected,
          );
        },
      );
    }

    return ListTile(
      leading: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      selectedColor: Colors.white,
      selectedTileColor: Colors.grey,
      title: Text(title),
      subtitle: summary != null
          ? Text(
              summary!,
              style: const TextStyle(color: Color(0xFFAAAAAA)),
            )
          : null,
      onTap: onTap,
    );
  }
}
