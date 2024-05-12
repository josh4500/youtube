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

import '../../account_avatar.dart';
import '../../network_image/custom_network_image.dart';

class ViewableVideoContext extends StatelessWidget {
  const ViewableVideoContext({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white12,
      child: Column(
        children: [
          Container(
            height: 227,
            decoration: const BoxDecoration(
              color: Colors.white38,
              image: DecorationImage(
                image: CustomNetworkImage('https://picsum.photos/450/900'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 4,
                ),
                child: AccountAvatar(size: 36),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Future, Metro BoomIn - Like That (Official Audio)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF1F1F1),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        RichText(
                          text: const TextSpan(
                            text: 'Future',
                            children: <InlineSpan>[
                              TextSpan(text: ' · '),
                              TextSpan(text: '1.8M views'),
                              TextSpan(text: ' · '),
                              TextSpan(text: '1 day ago'),
                            ],
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
