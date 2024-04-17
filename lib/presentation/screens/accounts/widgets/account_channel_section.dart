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
import 'package:youtube_clone/presentation/router/app_router.dart';
import 'package:youtube_clone/presentation/router/app_routes.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class AccountChannelSection extends StatelessWidget {
  const AccountChannelSection({
    super.key,
    required this.moreChannel,
  });
  final VoidCallback moreChannel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: <Widget>[
                AccountAvatar(size: 86, name: 'John Jackson'),
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
                    SizedBox(height: 4),
                    Text(
                      '@josh4500',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1 subscriber',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TappableArea(
            onTap: () {
              context.goto(
                AppRoutes.channelDescription.withPrefixParent(
                  AppRoutes.accounts,
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'More about this channel',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CustomActionChip(
                    alignment: Alignment.center,
                    backgroundColor: Color(0xff2c2c2c),
                    padding: EdgeInsets.all(12),
                    title: 'Manage videos',
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CustomActionChip(
                  alignment: Alignment.center,
                  icon: Icon(YTIcons.analytics_outlined),
                  padding: EdgeInsets.all(8),
                  backgroundColor: Color(0xff2c2c2c),
                ),
                SizedBox(width: 8),
                CustomActionChip(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  icon: Icon(YTIcons.edit_outlined),
                  backgroundColor: Color(0xff2c2c2c),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
