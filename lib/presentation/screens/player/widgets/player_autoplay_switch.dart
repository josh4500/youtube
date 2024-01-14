// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/presentation/preferences.dart';

class PlayerAutoplaySwitch extends ConsumerWidget {
  const PlayerAutoplaySwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoPlay = ref.watch(
      preferencesProvider.select((value) => value.autoplay),
    );
    return Switch(
      value: autoPlay,
      onChanged: (value) {
        ref.read(preferencesProvider.notifier).autoPlay = value;
      },
      activeColor: Colors.white,
      activeTrackColor: Colors.black12,
      inactiveTrackColor: Colors.black12,
      inactiveThumbColor: Colors.grey,
      thumbIcon: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return const Icon(
              Icons.play_arrow,
              color: Colors.black,
            );
          }
          return const Icon(
            Icons.pause,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
