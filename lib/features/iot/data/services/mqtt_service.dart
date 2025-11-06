import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:logging/logging.dart';

/// MQTT Service for communication with Pico W devices
class MqttService {
  final _logger = Logger('MqttService');
  MqttServerClient? _client;

  final String broker;
  final int port;
  final String? username;
  final String? password;

  // Stream controllers for different message types
  final _telemetryController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _accelDataController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController =
      StreamController<MqttConnectionState>.broadcast();

  Stream<Map<String, dynamic>> get telemetryStream =>
      _telemetryController.stream;
  Stream<Map<String, dynamic>> get accelDataStream =>
      _accelDataController.stream;
  Stream<MqttConnectionState> get connectionStream =>
      _connectionController.stream;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  MqttService({
    required this.broker,
    this.port = 1883,
    this.username,
    this.password,
  });

  /// Initialize and connect to MQTT broker
  Future<bool> connect() async {
    try {
      _logger.info('Connecting to MQTT broker: $broker:$port');

      _client = MqttServerClient.withPort(
          broker,
          'flutter_steps_tracker_${DateTime.now().millisecondsSinceEpoch}',
          port);
      _client!.logging(on: false);
      _client!.keepAlivePeriod = 60;
      _client!.onDisconnected = _onDisconnected;
      _client!.onConnected = _onConnected;
      _client!.onSubscribed = _onSubscribed;
      _client!.autoReconnect = true;
      _client!.resubscribeOnAutoReconnect = true;

      final connMessage = MqttConnectMessage()
          .withClientIdentifier(
              'flutter_steps_tracker_${DateTime.now().millisecondsSinceEpoch}')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);

      if (username != null && password != null) {
        connMessage.authenticateAs(username!, password!);
      }

      _client!.connectionMessage = connMessage;

      await _client!.connect();

      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        _logger.info('MQTT client connected successfully');
        _setupListeners();
        return true;
      } else {
        _logger.severe('MQTT connection failed: ${_client!.connectionStatus}');
        return false;
      }
    } catch (e) {
      _logger.severe('Error connecting to MQTT broker: $e');
      _client?.disconnect();
      return false;
    }
  }

  /// Subscribe to device telemetry topic
  void subscribeToDevice(String deviceId) {
    if (_client == null || !isConnected) {
      _logger.warning('Cannot subscribe: not connected');
      return;
    }

    final telemetryTopic = 'devices/$deviceId/telemetry';
    final accelTopic = 'devices/$deviceId/accel';

    _logger.info('Subscribing to topics for device: $deviceId');
    _client!.subscribe(telemetryTopic, MqttQos.atLeastOnce);
    _client!.subscribe(accelTopic, MqttQos.atLeastOnce);
  }

  /// Unsubscribe from device topics
  void unsubscribeFromDevice(String deviceId) {
    if (_client == null || !isConnected) return;

    _client!.unsubscribe('devices/$deviceId/telemetry');
    _client!.unsubscribe('devices/$deviceId/accel');
  }

  /// Send command to device (e.g., calibration, config change)
  void sendCommand(String deviceId, Map<String, dynamic> command) {
    if (_client == null || !isConnected) {
      _logger.warning('Cannot send command: not connected');
      return;
    }

    final topic = 'devices/$deviceId/commands';
    final payload = jsonEncode(command);

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _logger.info('Sending command to $deviceId: $command');
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  /// Setup message listeners
  void _setupListeners() {
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (final message in messages) {
        final recMessage = message.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);

        try {
          final Map<String, dynamic> data = jsonDecode(payload);

          // Route message based on topic
          if (message.topic.contains('/telemetry')) {
            _logger.fine('Telemetry received: $data');
            _telemetryController.add(data);
          } else if (message.topic.contains('/accel')) {
            _logger.fine('Accel data received: $data');
            _accelDataController.add(data);
          }
        } catch (e) {
          _logger.warning('Error parsing message: $e');
        }
      }
    });
  }

  void _onConnected() {
    _logger.info('MQTT client connected');
    _connectionController.add(MqttConnectionState.connected);
  }

  void _onDisconnected() {
    _logger.warning('MQTT client disconnected');
    _connectionController.add(MqttConnectionState.disconnected);
  }

  void _onSubscribed(String topic) {
    _logger.info('Subscribed to topic: $topic');
  }

  /// Disconnect from broker
  void disconnect() {
    _logger.info('Disconnecting from MQTT broker');
    _client?.disconnect();
  }

  /// Dispose all resources
  void dispose() {
    disconnect();
    _telemetryController.close();
    _accelDataController.close();
    _connectionController.close();
  }
}
