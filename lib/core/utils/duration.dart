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
    String hoursPart = (inMinutes / 60).floor().toString().padLeft(2, '0');
    String minutesPart = inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$hoursPart:$minutesPart';
  }
}
