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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_progress.dart';
import 'widgets/effect_options.dart';

final _checkMicrophoneCameraPerm = FutureProvider<bool>((ref) async {
  final result = await Future.wait([
    Permission.camera.isGranted,
    Permission.microphone.isGranted,
  ]);
  return result.fold<bool>(
    true,
    (value, element) => value && element,
  );
});

class CreateShortsScreen extends StatelessWidget {
  const CreateShortsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer(
        builder: (context, ref, child) {
          final permResult = ref.watch(_checkMicrophoneCameraPerm);
          return permResult.when(
            data: (bool granted) {
              if (granted) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Material(
                    child: Stack(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CreateProgress(),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CreateCloseButton(),
                                    CustomActionChip(
                                      icon: Icon(YTIcons.music),
                                      title: 'Add sound',
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      backgroundColor: Colors.black45,
                                    ),
                                    CreateShortsTimer(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            '60 seconds',
                            style: TextStyle(
                              fontSize: 36,
                              color: Colors.white12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * .45,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: SliderTheme(
                                      data: const SliderThemeData(
                                        trackHeight: 1,
                                        thumbColor: Colors.white,
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.white54,
                                      ),
                                      child: Slider(
                                        value: .5,
                                        onChanged: (v) {},
                                      ),
                                    ),
                                  ),
                                ),
                                const EffectOptions(
                                  items: [
                                    EffectItem(
                                      icon: YTIcons.flip_camera,
                                      label: 'Flip',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.speed,
                                      label: 'Speed',
                                    ),
                                    EffectItem(
                                      icon: Icons.timer_sharp,
                                      label: 'Timer',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.sparkle,
                                      label: 'Effects',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.green_screen,
                                      label: 'Green Screen',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.retouch,
                                      label: 'Retouch',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.filter_photo,
                                      label: 'Filter',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.lighting,
                                      label: 'Lighting',
                                    ),
                                    EffectItem(
                                      icon: YTIcons.flash_off,
                                      label: 'Flash',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 44,
                                          width: 56,
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 18.0,
                                          horizontal: 36,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '1X',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '2X',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '3X',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '4X',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '5X',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 36),
                                Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    const SizedBox(width: 36),
                                    const Icon(Icons.turn_left),
                                    const Spacer(),
                                    const Icon(Icons.turn_right),
                                    const SizedBox(width: 36),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        YTIcons.check_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 42.5,
                              horizontal: 12,
                            ),
                            child: CustomPaint(
                              size: const Size(66, 66),
                              foregroundPainter: CircledButton(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 56,
                            height: 56,
                            margin: const EdgeInsets.all(48),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF0000),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const CreateShortsPermissionRequest(
                checking: false,
              );
            },
            error: (e, _) => const CreateShortsPermissionRequest(),
            loading: CreateShortsPermissionRequest.new,
          );
        },
      ),
    );
  }
}

class CircledButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..color = Colors.white;
    canvas.drawCircle(
      Offset(size.halfWidth, size.halfHeight),
      size.halfWidth,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CreateShortsTimer extends StatefulWidget {
  const CreateShortsTimer({
    super.key,
  });

  @override
  State<CreateShortsTimer> createState() => _CreateShortsTimerState();
}

class _CreateShortsTimerState extends State<CreateShortsTimer> {
  int time = 15;
  static const int minTime = 15;
  static const int maxTime = 60;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        time == minTime ? time = maxTime : time = minTime;
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${time}s',
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          CircularProgressIndicator(
            color: Colors.white,
            value: time / maxTime,
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}

class OldCreateShortsPermissionRequest extends StatelessWidget {
  const OldCreateShortsPermissionRequest({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CreateProgress(),
        const SizedBox(height: 24),
        const CreateCloseButton(),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create a Short',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Allow access to your camera and microphone',
                  style: TextStyle(color: Colors.white24),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Text(
                    'Allow access',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CreateShortsPermissionRequest extends StatelessWidget {
  const CreateShortsPermissionRequest({
    super.key,
    this.checking = true,
  });

  final bool checking;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        image: checking
            ? null
            : const DecorationImage(
                image: CustomNetworkImage(''),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreateCloseButton(),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (checking) {
                  return const CheckPermission();
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(48.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'To record, let YouTube access your camera and microphone',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              CreateListReason(
                                icon: YTIcons.info_outlined,
                                title: 'Why is this needed?',
                                subtitle:
                                    'So you can take photos, record videos, and preview effects',
                              ),
                              SizedBox(height: 12),
                              CreateListReason(
                                icon: YTIcons.settings_outlined,
                                title: 'You are in control',
                                subtitle:
                                    'Change your permissions any time in Settings',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Consumer(
                          builder: (context, ref, child) {
                            return GestureDetector(
                              onTap: () async {
                                await Permission.camera.request();
                                await Permission.microphone.request();

                                ref.refresh(_checkMicrophoneCameraPerm);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CreateListReason extends StatelessWidget {
  const CreateListReason({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white70,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
