import 'package:flutter/cupertino.dart';

abstract class PlayerNotification extends Notification {}

class MinimizePlayerNotification extends PlayerNotification {}

class FullscreenPlayerNotification extends PlayerNotification {}

class ExpandPlayerNotification extends PlayerNotification {}

class DeExpandPlayerNotification extends PlayerNotification {}

class SettingsPlayerNotification extends PlayerNotification {}
