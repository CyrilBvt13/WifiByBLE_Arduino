import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:io' show Platform;

import '../../widgets/WifiDeviceListEntry.dart';
import 'SendCredentialsPage.dart';

//Parametres par défaut??
const String STA_DEFAULT_SSID = "STA_SSID";
const String STA_DEFAULT_PASSWORD = "STA_PASSWORD";
const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

class WifiDiscoveryPage extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  final BluetoothDevice server;

  const WifiDiscoveryPage({this.start = true, required this.server});

  @override
  _WifiDiscoveryPage createState() => new _WifiDiscoveryPage(server: server);
}

class _WifiDiscoveryPage extends State<WifiDiscoveryPage> {
  final BluetoothDevice server;

  List<WifiNetwork> _htResultNetwork = List<WifiNetwork>.empty(growable: true);

  bool _isEnabled = false;
  bool _isConnected = false;
  bool _isWifiEnableOpenSettings = false;
  bool _isWifiDisableOpenSettings = false;
  bool isDiscovering = false;

  _WifiDiscoveryPage({required this.server});

  @override
  void initState() {
    WiFiForIoTPlugin.isEnabled().then((val) {
      _isEnabled = val;
    });

    WiFiForIoTPlugin.isConnected().then((val) {
      _isConnected = val;
    });

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }

    super.initState();
  }

  void _restartDiscovery() {
    setState(() {
      isDiscovering = true;
    });

    _startDiscovery();
  }

  //Recherche des réseaux wifi
  void _startDiscovery() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = <WifiNetwork>[];
    }

    _htResultNetwork = htResultNetwork;

    setState(() {
      isDiscovering = false;
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering
            ? Text('Discovering networks')
            : Text('Discovered networks'),
        actions: <Widget>[
          Text(_htResultNetwork.length.toString()),
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView.builder(
          itemCount: _htResultNetwork.length,
          itemBuilder: (BuildContext context, index) {
            WifiNetwork oNetwork = _htResultNetwork[index];
            //final device = result.device;
            //final address = device.address;
            return WifiDeviceListEntry(oNetwork: oNetwork, onTap: () {
                Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ChatPage(arduino: server, wiFiSSID: oNetwork.ssid,);
          },
        ),
      );
              },);
          }),
    );
  }
}
