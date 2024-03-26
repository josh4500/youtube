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

import 'custom_action_chip.dart';
import 'over_scroll_glow_behavior.dart';

class GroupedViewBuilder extends StatelessWidget {
  const GroupedViewBuilder({
    super.key,
    required this.title,
    this.subtitle,
    this.width,
    this.height,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.direction = Axis.horizontal,
    required this.itemBuilder,
    this.onTap,
    this.itemCount,
  });

  final String title;
  final String? subtitle;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final Axis direction;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final VoidCallback? onTap;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int? itemCount;
  // TODO(Josh): Add useTappable property for the title tile
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              subtitle: subtitle != null
                  ? Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  : null,
              onTap: onTap,
            ),
            Positioned(
              top: 10,
              right: 12,
              child: CustomActionChip(
                title: 'View all',
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                border: const Border.fromBorderSide(
                  BorderSide(color: Colors.white12, width: 0.9),
                ),
                onTap: onTap,
              ),
            ),
          ],
        ),
        SizedBox(
          width: width,
          height: height,
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: ListView.builder(
              physics: physics,
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
              shrinkWrap: shrinkWrap,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
              scrollDirection: direction,
            ),
          ),
        ),
      ],
    );
  }
}
