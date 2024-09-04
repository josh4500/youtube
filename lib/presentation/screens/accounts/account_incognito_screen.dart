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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/provider/repository/account_repository_provider.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class AccountIncognitoScreen extends ConsumerWidget {
  const AccountIncognitoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsPath.accountIncognito108,
                  width: 96,
                  height: 96,
                  color: const Color(0xFFCCCCCC),
                ),
              ),
              const SizedBox(height: 44),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 48.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: const Text(
                  'Nothing is added to the "You" tab while you\'re incognito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TappableArea(
                onTap: () {
                  ref.read(accountRepositoryProvider).turnOffIncognito();
                },
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12,
                ),
                child: const Text(
                  'Turn off Incognito',
                  style: TextStyle(
                    color: AppPalette.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Column(
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(
                  color: AppPalette.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
