import 'package:flutter/widgets.dart';

import '../editor/element.dart' show TextElement, ElementData;

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

  final ElementData element;
}

class UpdateElementNotification extends EditorNotification {
  UpdateElementNotification({
    required this.element,
    this.swapToLast = false,
  });

  final bool swapToLast;
  final ElementData element;
}

class DeleteElementNotification extends EditorNotification {
  DeleteElementNotification({required this.elementId});

  final int elementId;
}
