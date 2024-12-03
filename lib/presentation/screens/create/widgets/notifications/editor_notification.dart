import 'package:flutter/widgets.dart';
import 'package:youtube_clone/presentation/screens/create/widgets/editor/elements/element.dart';

abstract class EditorNotification extends Notification {}

class OpenTimelineNotification extends EditorNotification {}

class CloseTimelineNotification extends EditorNotification {}

class OpenTextEditorNotification extends EditorNotification {
  OpenTextEditorNotification({required this.element});

  final TextElement element;
}

class OpenStickerEditorNotification extends EditorNotification {
  OpenStickerEditorNotification({required this.type});

  final Type type;
}

class CloseElementEditorNotification extends EditorNotification {}

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
  DeleteElementNotification({required this.elementId});

  final int elementId;
}
