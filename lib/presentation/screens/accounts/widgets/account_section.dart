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
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/providers.dart';
import 'package:youtube_clone/presentation/router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../settings/settings_screen.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountStateProvider);
    final isChannel = account.isChannel;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (isChannel) {
                context.goto(AppRoutes.accountChannel);
              } else {
                // TODO(josh4500): Create account
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: <Widget>[
                  const AccountAvatar(size: 76),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        switch (account) {
                          UserViewModel _ => account.name,
                          ChannelViewModel _ => account.name,
                          AccountViewModel() => throw UnimplementedError(),
                        },
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                        ),
                        child: Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: switch (account) {
                                  UserViewModel _ => 'Create channel',
                                  ChannelViewModel _ => '@${account.tag}',
                                  AccountViewModel() =>
                                    throw UnimplementedError(),
                                },
                                children: [
                                  if (isChannel) ...[
                                    const TextSpan(text: kDotSeparator),
                                    const TextSpan(text: 'View channel'),
                                  ],
                                ],
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFAAAAAA),
                              ),
                            ),
                            const Icon(YTIcons.chevron_right, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: ScrollConfiguration(
              behavior: const OverScrollGlowBehavior(enabled: false),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  CustomActionChip(
                    title: 'Switch account',
                    onTap: () => showAccountDialog(context),
                    icon: const Icon(YTIcons.switch_accounts, size: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 8.55),
                    padEnd: true,
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Google Account',
                    onTap: () {},
                    icon: const Icon(YTIcons.google, size: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 8.55),
                    padEnd: true,
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Turn on incognito',
                    onTap: () {
                      ref.read(accountRepositoryProvider).turnOnIncognito();
                    },
                    icon: const Icon(Icons.privacy_tip, size: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 8.55),
                    padEnd: true,
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Share channel',
                    onTap: () {},
                    icon: const Icon(YTIcons.share_outlined, size: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 8.55),
                    padEnd: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
