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

import 'package:flutter/cupertino.dart';

abstract class PlayerNotification extends Notification {}

class MinimizePlayerNotification extends PlayerNotification {}

class UnlockPlayerNotification extends PlayerNotification {}

class RotatePlayerNotification extends PlayerNotification {}

class EnterFullscreenPlayerNotification extends PlayerNotification {}

class ExitFullscreenPlayerNotification extends PlayerNotification {}

class EnterExpandPlayerNotification extends PlayerNotification {}

class ExitExpandPlayerNotification extends PlayerNotification {}

class SettingsPlayerNotification extends PlayerNotification {}

abstract class SeekStartPlayerNotification extends PlayerNotification {}

abstract class SeekUpdatePlayerNotification extends PlayerNotification {}

abstract class SeekEndPlayerNotification extends PlayerNotification {}

class ForwardSeekPlayerNotification extends PlayerNotification {}

class RewindSeekPlayerNotification extends PlayerNotification {}

class Forward2xSpeedStartPlayerNotification
    extends SeekStartPlayerNotification {}

class Forward2xSpeedEndPlayerNotification extends SeekEndPlayerNotification {}

class SlideSeekStartPlayerNotification extends SeekStartPlayerNotification {
  SlideSeekStartPlayerNotification({this.lockProgress = false});

  final bool lockProgress;
}

class SlideSeekUpdatePlayerNotification extends SeekUpdatePlayerNotification {
  SlideSeekUpdatePlayerNotification({
    required this.duration,
    required this.showRelease,
  });

  final Duration duration;
  final bool showRelease;
}

class SlideSeekEndPlayerNotification extends SeekEndPlayerNotification {}
