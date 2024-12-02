import 'package:flutter/widgets.dart';
import 'package:youtube_clone/presentation/screens/create/widgets/editor/elements/element.dart';

abstract class EditorNotification extends Notification {}

class OpenTimelineNotification extends EditorNotification {}

class CloseTimelineNotification extends EditorNotification {}

class CloseElementEditortNotification extends EditorNotification {}

class CreateElementNotification extends EditorNotification {
  CreateElementNotification({required this.element});

  final VideoElementData element;
}

class UpdateElementNotification extends EditorNotification {
  UpdateElementNotification({
    required this.element,
    this.swapToLast = false,
  });

  final bool swapToLast;
  final VideoElementData element;
}

class DeleteElementNotification extends EditorNotification {
  DeleteElementNotification();
}
