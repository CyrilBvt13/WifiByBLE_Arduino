  
//Dart and Flutter packages
import 'package:flutter/material.dart';

//ADD device_info package
//ADD location package

//Package for Android release
import 'package:device_info/device_info.dart';

//Package for bluetooth functions
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

//Package for wifi functions
import 'package:wifi_iot/wifi_iot.dart';

//Package for location
import 'package:location/location.dart';

//Other pages that will be called from here
import 'modules/wifibyBLE/SelectBondedDevicePage.dart';
import 'modules/wifibyBLE/WifiDiscoveryPage.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {

  //Bool for bluetooth state (enable or disable)
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  //Bool for wifi state (enable or disable)
  bool _wifiState = false;
  bool _isWifiEnableOpenSettings = false;
  bool _isWifiDisableOpenSettings = false;

  //Bool for location
  Location location = new Location();
  bool _locationState = false;

  var androidInfo;

  @override
  void initState() {
    super.initState();

    androidInfo = DeviceInfoPlugin().androidInfo;

    // Get current bluetooth state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Get current wifi state
    WiFiForIoTPlugin.isEnabled().then((state) {
      setState(() {
        _wifiState = state;
      });
    });

    // Get current location state
    location.serviceEnabled().then((state) {
      setState(() {
        _locationState= state;
      });
    });

    // Listen for futher bluetooth state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    //COMPLETE
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          //If Android release is >10 we must test bluetooth and navigation
          (!_bluetoothState.isEnabled)
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: 
                          (androidInfo.version.release >= 10)
                          ? Text("Bluetooth and navigation must be enabled")
                          : Text("Bluetooth must be enabled"),
                          actions: <Widget>[
                            //Switch for enabling bluetooth
                            new Switch(
                              value: _bluetoothState.isEnabled,
                              onChanged: (bool value) {
                                future() async {
                                  if (value)
                                    await FlutterBluetoothSerial.instance
                                        .requestEnable();
                                  else
                                    await FlutterBluetoothSerial.instance
                                        .requestDisable();
                                }
                                future().then((_) {
                                  setState(() {
                                    value = value;
                                  });
                                  //If bluetooth and navigation are enabled then push to SelectBondedDevicePage
                                  if(androidInfo.version.release >= 10){
                                    if(_locationState==true){
                                      if (_bluetoothState.isEnabled){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SelectBondedDevicePage(
                                                checkAvailability: false);
                                          },
                                        ),
                                      );
                                    }else{
                                      return;
                                    };
                                  }else{
                                    
                                    if (_bluetoothState.isEnabled){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SelectBondedDevicePage(
                                                checkAvailability: false);
                                          },
                                        ),
                                      );
                                    }else{
                                      return;
                                    };
                                  };
                                  };
                                });
                              },
                            ),
                            //Switch for enabling navigation only if Android Release > 10
                            (androidInfo.version.release >= 10)
                            ? new Switch(
                              value: _locationState,
                              onChanged: (bool value) {
                                future() async {
                                  if (value)
                                    await location.requestService();
                                  else
                                    return;
                                }
                                future().then((_) {
                                  setState(() {
                                    value = value;
                                  });
                                  //If bluetooth and navigation are enabled then push to SelectBondedDevicePage
                                  if (_bluetoothState.isEnabled && _locationState==true){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return SelectBondedDevicePage(
                                            checkAvailability: false);
                                      },
                                    ),
                                  );
                                  };
                                });
                              },
                            )
                            : new Container(),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    final BluetoothDevice? selectedDevice =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(
                              checkAvailability: false);
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Connect -> selected ' + selectedDevice.address);
                      _startChat(context, selectedDevice);
                    } else {
                      print('Connect -> no device selected');
                    }
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                  ),
                ),
        ],
      ),
      body: Container(),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    //si wifi et navigation activé et si device disponible <------------- ERREUR ICI
    if (_wifiState == true && server.isBonded == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            //return ChatPage(arduino: server);
            return WifiDiscoveryPage(server: server);
          },
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Wifi must be enabled"),
            actions: <Widget>[
              new Switch(
                value: _wifiState,
                onChanged: (bool value) {
                  future() async {
                    if (value)
                      WiFiForIoTPlugin.setEnabled(true,
                          shouldOpenSettings: _isWifiEnableOpenSettings);
                    else
                      WiFiForIoTPlugin.setEnabled(false,
                          shouldOpenSettings: _isWifiDisableOpenSettings);
                  }
                  future().then((_) {
                    setState(() {
                      value = value;
                    });
                    //If wifi and navigation are enabled then push to WifiDiscoveryPage
                    if(_wifiState==true){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return WifiDiscoveryPage(server: server);
                        },
                      ),
                    );
                    }else{
                      return;
                    };
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }
}