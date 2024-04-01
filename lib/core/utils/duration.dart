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

extension DurationUtils on Duration {
  String get hoursMinutesWords {
    String hoursPart = inHours > 1
        ? '$inHours hours'
        : inHours < 1
            ? ''
            : 'hour';
    final minutesPart = inMinutes.remainder(60) > 0
        ? ' ${inMinutes.remainder(60)} minutes'
        : '';

    hoursPart =
        inHours == 1 && inMinutes.remainder(60) > 0 ? '1 hour' : hoursPart;

    return '$hoursPart$minutesPart';
  }

  int get hourPart => (inMinutes / 60).floor();
  int get minutesPart => inMinutes.remainder(60);

  String get hoursMinutes {
    final String hoursPart =
        (inMinutes / 60).floor().toString().padLeft(2, '0');
    final String minutesPart =
        inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$hoursPart:$minutesPart';
  }

  String get hoursMinutesSeconds {
    final String hoursPart =
        (inMinutes / 60).floor().toString().padLeft(2, '0');
    final String minutesPart =
        inMinutes.remainder(60).toString().padLeft(2, '0');
    final String secondsPart =
        inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${(inMinutes / 60) > 1 ? '$hoursPart:' : ''}$minutesPart:$secondsPart';
  }
}

extension ClampDurationExtension on Duration {
  Duration clamp(Duration min, Duration max) {
    return this < min
        ? min
        : this > max
            ? max
            : this;
  }
}
