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
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({
    super.key,
    this.onTapChannelInfo,
    this.onTapSwitchAccount,
    this.onTapGoogleAccount,
    this.onTapIncognito,
  });
  final VoidCallback? onTapChannelInfo;
  final VoidCallback? onTapSwitchAccount;
  final VoidCallback? onTapGoogleAccount;
  final VoidCallback? onTapIncognito;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapChannelInfo,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                children: <Widget>[
                  AccountAvatar(size: 76),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Josh',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text('@josh4500', style: TextStyle(fontSize: 12)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 6.0,
                            ),
                            child: Text(
                              '·',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'View channel',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Center(
                            child: Icon(
                              YTIcons.chevron_right,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 30,
            child: ScrollConfiguration(
              behavior: const OverScrollGlowBehavior(enabled: false),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  CustomActionChip(
                    title: 'Switch account',
                    onTap: onTapSwitchAccount,
                    icon: const Icon(YTIcons.switch_accounts, size: 16),
                    backgroundColor: const Color(0xFF272727),
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Google Account',
                    onTap: onTapGoogleAccount,
                    icon: const Icon(YTIcons.google, size: 16),
                    backgroundColor: const Color(0xFF272727),
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Turn on incognito',
                    onTap: onTapIncognito,
                    icon: const Icon(Icons.privacy_tip, size: 16),
                    backgroundColor: const Color(0xFF272727),
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
