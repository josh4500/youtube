import 'package:flutter/widgets.dart';
import 'package:youtube_clone/presentation/screens/create/widgets/editor/elements/element.dart';

abstract class EditorNotification extends Notification {}

class OpenTimelineNotification extends EditorNotification {}

class CloseTimelineNotification extends EditorNotification {}

class CreateElementNotification extends EditorNotification {
  CreateElementNotification({required this.element, this.updateIndex});

  final int? updateIndex;
  final VideoElementData element;
}

class DeleteElementNotification extends EditorNotification {}
