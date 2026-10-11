import 'package:flutter/services.dart';

import 'robot_channels.dart';
import 'robot_controller.dart';
import 'robot_event.dart';

/// Kotlin temi 브리지를 플랫폼 채널로 부르는 실기용 구현.
class TemiRobotController implements RobotController {
  TemiRobotController({MethodChannel? method, EventChannel? events})
    : _method = method ?? const MethodChannel(RobotChannels.method),
      _eventChannel = events ?? const EventChannel(RobotChannels.events);

  final MethodChannel _method;
  final EventChannel _eventChannel;

  late final Stream<RobotEvent> _events = _eventChannel
      .receiveBroadcastStream()
      .map((raw) => RobotEvent.fromMap(raw as Map<Object?, Object?>))
      .where((event) => event != null)
      .cast<RobotEvent>();

  @override
  Stream<RobotEvent> get events => _events;

  @override
  Future<bool> isReady() async =>
      await _method.invokeMethod<bool>('isReady') ?? false;

  @override
  Future<List<String>> getLocations() async =>
      await _method.invokeListMethod<String>('getLocations') ?? const [];

  @override
  Future<void> saveLocation(String key) =>
      _method.invokeMethod('saveLocation', {'key': key});

  @override
  Future<void> deleteLocation(String key) =>
      _method.invokeMethod('deleteLocation', {'key': key});

  @override
  Future<void> goTo(String key) => _method.invokeMethod('goTo', {'key': key});

  @override
  Future<void> stopMovement() => _method.invokeMethod('stopMovement');

  @override
  Future<void> speak(String text) =>
      _method.invokeMethod('speak', {'text': text});

  @override
  Future<void> dispose() async {}
}
