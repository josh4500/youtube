import 'package:flutter/material.dart';

enum VideoBottomSheet {
  comment,
  chapter,
  playlist,
  description,
  membership,
  product,
  news,
  clip,
  thanks,
}

abstract class VideoScreenNotification extends Notification {}

class OpenBottomSheetNotification extends VideoScreenNotification {
  OpenBottomSheetNotification({required this.sheet});

  final VideoBottomSheet sheet;
}

class CloseBottomSheetNotification extends VideoScreenNotification {
  CloseBottomSheetNotification({required this.sheet});

  final VideoBottomSheet sheet;
}

class OpenCommentNotification extends VideoScreenNotification {}
