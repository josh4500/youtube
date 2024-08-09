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
import 'package:youtube_clone/presentation/constants.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class VideoActions extends StatelessWidget {
  const VideoActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2.5,
        ),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF272727),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Row(
              children: [
                CustomActionButton(
                  title: '336',
                  leadingWidth: 4,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  icon: Icon(YTIcons.like_outlined, size: 18),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Divider(height: 0, thickness: 1),
                  ),
                ),
                CustomActionButton(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  icon: Icon(YTIcons.dislike_outlined, size: 18),
                ),
              ],
            ),
          ),
          const CustomActionChip(
            title: 'Share',
            backgroundColor: Color(0xFF272727),
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 4),
            icon: Icon(YTIcons.shared_filled, size: 18),
          ),
          CustomActionChip(
            title: 'Remix',
            backgroundColor: const Color(0xFF272727),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            icon: const Icon(Icons.wifi_channel_outlined, size: 18),
            onTap: () => onRemixClicked(context),
          ),
          const CustomActionChip(
            title: 'Thanks',
            backgroundColor: Color(0xFF272727),
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 4),
            icon: Icon(YTIcons.thanks_outlined, size: 18),
          ),
          CustomActionButton(
            title: 'Download',
            backgroundColor: const Color(0xFF272727),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            icon: const Icon(YTIcons.download_outlined, size: 18),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            onTap: () => onDownloadClicked(context),
          ),
          const CustomActionChip(
            title: 'Clip',
            backgroundColor: Color(0xFF272727),
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 4),
            icon: Icon(YTIcons.clip_outlined, size: 18),
          ),
          CustomActionChip(
            title: 'Save',
            backgroundColor: const Color(0xFF272727),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            icon: const Icon(YTIcons.save_outlined, size: 18),
            onTap: () => onSaveClicked(context),
            onLongPress: () => onSaveClicked(context),
          ),
          const CustomActionChip(
            title: 'Report',
            backgroundColor: Color(0xFF272727),
            padding: EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.symmetric(horizontal: 4),
            icon: Icon(YTIcons.report_outlined, size: 18),
          ),
        ],
      ),
    );
  }

  Future<void> onRemixClicked(BuildContext context) async {
    await showDynamicSheet(
      context,
      title: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Text(
          'Remix',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      items: [
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.music),
          title: 'Sound',
          subtitle: 'Use the sound from this video',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(Icons.people_outline),
          title: 'Collab',
          subtitle: 'Create alongside this video',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.green_screen),
          title: 'Green Screen',
          subtitle: 'Use this video as a background',
        ),
        const DynamicSheetOptionItem(
          leading: Icon(YTIcons.trim),
          title: 'Cut',
          subtitle: 'use a segment from this video',
        ),
      ],
    );
  }

  Future<void> onSaveClicked(BuildContext context) async {
    await showDynamicSheet(
      context,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Text(
                  'Save video to...',
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(),
                TappableArea(
                  borderRadius: BorderRadius.circular(24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Row(
                    children: [
                      Icon(YTIcons.save_outlined, color: Color(0xFF3EA6FF)),
                      SizedBox(width: 8),
                      Text(
                        'New playlist',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3EA6FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 0),
        ],
      ),
      trailing: Column(
        children: [
          const Divider(thickness: 1, height: 0),
          CustomInkWell(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(YTIcons.check_outlined),
                  SizedBox(width: 16),
                  Text('Done', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
      items: [
        const DynamicSheetOptionItem(
          leading: CustomCheckBox(selected: true),
          title: 'Watch later',
          trailing: Icon(YTIcons.private_circle_outlined),
          useTappable: true,
          exitOnTap: false,
        ),
      ],
    );
  }

  Future<void> onDownloadClicked(BuildContext context) async {
    await showDynamicSheet(
      context,
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text('Download quality', style: TextStyle(fontSize: 18)),
      ),
      trailing: Column(
        children: [
          const Divider(thickness: 1, height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: CustomActionChip(
                    onTap: () {},
                    title: 'Cancel',
                    alignment: Alignment.center,
                    backgroundColor: Colors.transparent,
                    border: Border.all(color: Colors.white12),
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(64),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3EA6FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomActionChip(
                    onTap: () {},
                    title: 'Download',
                    alignment: Alignment.center,
                    backgroundColor: const Color(0xFF3EA6FF),
                    border: Border.all(color: Colors.white12),
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(64),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF0F0F0F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      items: [
        const DynamicSheetOptionItem(
          leading: CustomRadio(selected: true),
          title: 'Medium(360p)',
          useTappable: true,
          exitOnTap: false,
          trailing: Text(
            '162 MB',
            style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
          ),
        ),
        const DynamicSheetOptionItem(
          leading: CustomRadio(selected: false),
          title: 'Low(144p)',
          useTappable: true,
          exitOnTap: false,
          trailing: Text(
            '96 MB',
            style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
          ),
        ),
        DynamicSheetSection(
          child: Column(
            children: [
              const Divider(thickness: 1, height: 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AssetsPath.ytPremiumFullLogoDarkBig,
                    fit: BoxFit.fitHeight,
                    height: 40,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'For high quality unlimited downloads, ad-free and background play, get YouTube Premium.',
                      style: TextStyle(color: Color(0xffaaaaaa)),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
        const DynamicSheetOptionItem(
          leading: CustomRadio(selected: false),
          title: 'Full HD (1080p)',
          useTappable: true,
          exitOnTap: false,
          trailing: Text(
            '505 MB',
            style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
          ),
        ),
        const DynamicSheetOptionItem(
          leading: CustomRadio(selected: false),
          title: 'High (720p)',
          useTappable: true,
          exitOnTap: false,
          trailing: Text(
            '326 MB',
            style: TextStyle(fontSize: 16, color: Color(0xFFAAAAAA)),
          ),
        ),
        const DynamicSheetSection(child: Divider(thickness: 1, height: 0)),
        const DynamicSheetOptionItem(
          leading: CustomCheckBox(selected: false),
          title: 'Remember my settings for 30 days',
          useTappable: true,
          exitOnTap: false,
        ),
      ],
    );
  }
}
