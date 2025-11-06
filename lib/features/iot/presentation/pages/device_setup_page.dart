import 'package:flutter/material.dart';

/// Device Configuration and Setup Screen
class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({Key? key}) : super(key: key);

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final _deviceIdController = TextEditingController();
  final _deviceNameController = TextEditingController();
  final _brokerController = TextEditingController(text: 'broker.hivemq.com');
  final _portController = TextEditingController(text: '1883');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isScanning = false;
  bool _useAuthentication = false;

  @override
  void dispose() {
    _deviceIdController.dispose();
    _deviceNameController.dispose();
    _brokerController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Setup'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Add New Pico W Device',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure your Raspberry Pi Pico W step counter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),

            // Device Information Section
            _buildSectionTitle('Device Information'),
            const SizedBox(height: 16),

            TextField(
              controller: _deviceIdController,
              decoration: const InputDecoration(
                labelText: 'Device ID',
                hintText: 'pico-01',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.devices),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                hintText: 'My Step Counter',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 32),

            // MQTT Broker Configuration
            _buildSectionTitle('MQTT Broker Settings'),
            const SizedBox(height: 16),

            TextField(
              controller: _brokerController,
              decoration: const InputDecoration(
                labelText: 'Broker Address',
                hintText: 'broker.hivemq.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.cloud),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '1883',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.settings_ethernet),
              ),
            ),
            const SizedBox(height: 16),

            // Authentication toggle
            SwitchListTile(
              title: const Text('Use Authentication'),
              subtitle: const Text('Enable if your broker requires login'),
              value: _useAuthentication,
              onChanged: (value) {
                setState(() {
                  _useAuthentication = value;
                });
              },
            ),

            if (_useAuthentication) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Quick Setup Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Setup Guide',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStep('1', 'Power on your Pico W device'),
                    _buildStep('2', 'Ensure it\'s connected to WiFi'),
                    _buildStep('3', 'Enter the Device ID from the Pico'),
                    _buildStep('4', 'Configure MQTT broker settings'),
                    _buildStep('5', 'Click "Connect Device" below'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isScanning ? null : _scanForDevices,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isScanning ? 'Scanning...' : 'Scan Network'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _connectDevice,
                    icon: const Icon(Icons.link),
                    label: const Text('Connect Device'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Advanced Settings
            ExpansionTile(
              title: const Text('Advanced Settings'),
              children: [
                _buildAdvancedOption(
                  'Debug Mode',
                  'Receive raw accelerometer data',
                  true,
                ),
                _buildAdvancedOption(
                  'Auto Reconnect',
                  'Automatically reconnect if connection lost',
                  true,
                ),
                _buildAdvancedOption(
                  'Background Sync',
                  'Sync data even when app is closed',
                  false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue[900]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOption(
      String title, String subtitle, bool initialValue) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: initialValue,
      onChanged: (value) {
        // TODO: Implement setting change
      },
    );
  }

  void _scanForDevices() {
    setState(() {
      _isScanning = true;
    });

    // TODO: Implement network scan for Pico W devices
    // This could use mDNS/Bonjour or a custom discovery protocol

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });

        // Show found devices dialog
        _showFoundDevicesDialog();
      }
    });
  }

  void _showFoundDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Devices Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Pico-01'),
              subtitle: const Text('192.168.1.100'),
              onTap: () {
                setState(() {
                  _deviceIdController.text = 'pico-01';
                  _deviceNameController.text = 'Pico W Step Counter';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _connectDevice() {
    // Validate inputs
    if (_deviceIdController.text.isEmpty) {
      _showError('Please enter a Device ID');
      return;
    }

    if (_brokerController.text.isEmpty) {
      _showError('Please enter a broker address');
      return;
    }

    // TODO: Implement actual device connection via BLoC
    // 1. Create MqttService with broker settings
    // 2. Connect to broker
    // 3. Subscribe to device topics
    // 4. Register device in local storage

    _showSuccess('Device connected successfully!');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back after short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
