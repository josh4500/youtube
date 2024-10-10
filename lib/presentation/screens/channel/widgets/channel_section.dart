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

class ChannelSection extends StatelessWidget {
  const ChannelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 12.0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  const AccountAvatar(size: 88, name: 'John Jackson'),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          Text(
                            'Marques Brownlee',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8),
                          // Icon(YTIcons.music_outlined, size: 20),
                          Icon(YTIcons.verified_filled, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '@mkbhd',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: const TextSpan(
                          text: '18M subscribers',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          children: <InlineSpan>[
                            TextSpan(text: '  '),
                            TextSpan(text: '1.6k videos'),
                          ],
                        ),
                      ),
                    ],
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
                AppRoutes.subscriptions,
              ),
            );
          },
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12.0,
          ),
          child: const Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  'MKBHD Quality Tech Videos | YouTube | Geek | Consumer Electronics | Tech Head | Internet Personality!',
                  maxLines: 2,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(width: 32),
              Icon(
                YTIcons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        const TappableArea(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
          child: Row(
            children: <Widget>[
              Text(
                'twitter.com/MKBHD and 4 more links',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: SubscribedChannelButton(
                      title: 'Subscribed',
                      alignment: Alignment.center,
                      backgroundColor: Colors.white12,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomActionChip(
                      title: 'Join',
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomActionChip(
                title: 'Visit store',
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
