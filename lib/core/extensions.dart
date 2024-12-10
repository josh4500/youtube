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

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'enums/date_group_head.dart';

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  /// The first element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.firstWhereOrNull((element) => element < 5); // 1
  /// result = numbers.firstWhereOrNull((element) => element > 5); // 6
  /// result = numbers.firstWhereOrNull((element) => element > 10); // null
  /// ```
  ///
  /// If no element satisfies [test], `null` is returned;
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}

extension LastWhereOrNullExtension<T> on Iterable<T> {
  /// The Last element that satisfies the given predicate [test].
  ///
  /// Iterates through elements and returns the first to satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.lastWhereOrNull((element) => element < 5); // 1
  /// result = numbers.lastWhereOrNull((element) => element > 5); // 6
  /// result = numbers.lastWhereOrNull((element) => element > 10); // null
  /// ```
  ///
  /// If no element satisfies [test], `null` is returned;
  T? lastWhereOrNull(bool Function(T) test) {
    try {
      return lastWhere(test);
    } catch (e) {
      return null;
    }
  }
}

extension RemoveFirstExtension<T> on List<T> {
  T removeFirst() {
    return removeAt(0);
  }
}

typedef GroupChecker<T> = bool Function(T item);

class Grouper<T> {
  Grouper({this.checker});

  final GroupChecker<T>? checker;

  Type get type => T;
  bool callback(dynamic item) => checker?.call(item) ?? item.runtimeType == T;
}

class GroupedItems<T> {
  GroupedItems(this.type);

  final Type type;
  final List<T> items = [];

  operator [](int index) => items[index];
  int get length => items.length;

  @override
  String toString() => type.toString();
}

extension GrouperExtension<T> on List<T> {
  List<GroupedItems<T>> group(List<Grouper<T>> groupers) {
    final List<GroupedItems<T>> groups = [];
    GroupedItems<T> currentGroup = GroupedItems<T>(Type);

    for (final item in this) {
      for (final grouper in groupers) {
        // if (grouper.checker != null && grouper.callback(item)) {
        //   currentGroup = GroupedItems<T>(item.runtimeType);
        //   break;
        // }
        // if (grouper.checker != null) continue;
        if (grouper.callback(item) && grouper.type != currentGroup.type) {
          currentGroup = GroupedItems<T>(item.runtimeType);
          break;
        }
      }

      currentGroup.items.add(item);
      // Adds new group created
      if (currentGroup.items.length == 1) groups.add(currentGroup);
    }

    return groups;
  }
}

extension DateGroupingExtension on DateTime {
  bool compareYMD(DateTime time) {
    return day == time.day && year == time.year && month == time.month;
  }

  bool get isToday => compareYMD(DateTime.now());
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return compareYMD(yesterday);
  }

  bool get isSameWeek => weekNum(DateTime.now()) == weekNum(this);
  bool get isSameYear => DateTime.now().year == year;
  bool get isSameMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  int weekNum(DateTime date) {
    final a = DateTime(date.year);
    final b = DateTime(date.year, date.month, date.day);
    // Number of days since beginning of the year
    final d = (b.millisecondsSinceEpoch - a.millisecondsSinceEpoch) / 86400000;
    return ((d + a.day + 1) / 7).ceil();
  }

  String get header {
    String dateGroup;
    if (isToday) {
      dateGroup = 'Today';
    } else if (isYesterday) {
      dateGroup = 'Yesterday';
    } else if (isSameWeek) {
      dateGroup = 'This week';
    } else if (isSameMonth) {
      dateGroup = 'This month';
    } else if (isSameYear) {
      dateGroup = DateFormat('MMM, dd').format(this);
    } else {
      dateGroup = DateFormat('MMM, dd yyyy').format(this);
    }

    return dateGroup;
  }

  DateHead get asHeader {
    DateHead dateGroup;
    if (isToday) {
      dateGroup = DateHead.today;
    } else if (isYesterday) {
      dateGroup = DateHead.yesterday;
    } else if (isSameWeek) {
      dateGroup = DateHead.week;
    } else if (isSameMonth) {
      dateGroup = DateHead.month;
    } else if (isSameYear) {
      dateGroup = DateHead.year;
    } else {
      dateGroup = DateHead.other;
    }

    return dateGroup;
  }
}

extension AgoExtension on DateTime {
  String get ago {
    return 'ago';
  }
}

extension IfNullExtension<T> on T? {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}

/// Extension methods for the AxisDirection enum to provide convenient
/// ways to check its direction and alignment properties.
extension DirectionExtension on AxisDirection {
  /// Returns true if this direction is [AxisDirection.left].
  bool get isLeft => this == AxisDirection.left;

  /// Returns true if this direction is [AxisDirection.right].
  bool get isRight => this == AxisDirection.right;

  /// Returns true if this direction is [AxisDirection.up].
  bool get isUp => this == AxisDirection.up;

  /// Returns true if this direction is [AxisDirection.down].
  bool get isDown => this == AxisDirection.down;

  /// Returns true if this direction is horizontal (left or right).
  bool get isHorizontal =>
      this == AxisDirection.left || this == AxisDirection.right;

  /// Returns true if this direction is vertical (up or down).
  bool get isVertical => this == AxisDirection.up || this == AxisDirection.down;
}

/// Returns the corresponding [Alignment] for the given [direction]
/// that positions a child widget at the center of the sliding area.
Alignment axisDirectionToCenterAlignment(AxisDirection direction) {
  switch (direction) {
    case AxisDirection.left:
      return Alignment.centerLeft;
    case AxisDirection.up:
      return Alignment.topCenter;
    case AxisDirection.right:
      return Alignment.centerRight;
    case AxisDirection.down:
      return Alignment.bottomCenter;
  }
}
