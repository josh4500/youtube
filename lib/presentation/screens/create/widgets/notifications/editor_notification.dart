import 'package:flutter/widgets.dart';
import 'package:youtube_clone/presentation/screens/create/widgets/editor/artifacts/artifact.dart';

abstract class EditorNotification extends Notification {}

class OpenTimelineNotification extends EditorNotification {}

class CloseTimelineNotification extends EditorNotification {}

class CreateArtifactNotification extends EditorNotification {
  CreateArtifactNotification({required this.artifact, this.updateIndex});

  final int? updateIndex;
  final ArtifactData artifact;
}
