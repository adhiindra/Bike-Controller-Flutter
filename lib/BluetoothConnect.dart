import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



class BluetoothConnect extends StatefulWidget {
  const BluetoothConnect({Key? key}) : super(key: key);
  @override
  _BluetoothConnectState createState() => _BluetoothConnectState();

}

class _BluetoothConnectState extends State<BluetoothConnect> {

  bool firstBT = true;
  var BluetoothDevices = ['HC-01','iPHONE','Samsung AAA','Macbook Pro','Asus Pro Max'];
  String selDevices = 'Select Devices';

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

// Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

// Track the Bluetooth connection with the remote device
  late BluetoothConnection connection;

// To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection.isConnected;

  late int _deviceState;
  bool isDisconnecting = false;
  List<BluetoothDevice> _devicesList = [];
  late BluetoothDevice _device;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the Bluetooth of the device is not enabled,
    // then request permission to turn on Bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // For retrieving the paired devices list
        getPairedDevices();
      });
    });
  }

  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the Bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  Widget connectBtWidget(){
    return StatefulBuilder(builder: (context, StateSetter setState){
      return Column(
          children: <Widget>[
            Text('BLUETOOTH LIST',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),),
            SizedBox(height: 10,),
            Text('Select Bluetooth Devices Below for Connect to Arduino.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),),
            SizedBox(height: 10,),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 8,
                maxHeight: MediaQuery.of(context).size.height / 5,
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Material(
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            selDevices = _devicesList[index].name!;
                            _device = _devicesList[index];
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.devices,
                                            size: 20,
                                          ),
                                          SizedBox(width: 20,),
                                          Text(_devicesList.isEmpty? 'None' : _devicesList[index].name!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              decoration: TextDecoration.none,
                                            ),),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.link,
                                      size: 20,
                                    ),
                                  ],
                                ),

                                SizedBox(height: 6,),
                                Divider(height: 0,)
                              ]
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: BluetoothDevices.length,
              ),
            ),
            SizedBox(height: 20,),
            Text('$selDevices',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),),
            SizedBox(height: 5,),
            ElevatedButton(
                onPressed: (){
                  if(_device == null){
                    setState((){
                      selDevices = 'No Devices Selected';
                    });
                  }

                },
                child: Text('CONNECT',
                  style: TextStyle(
                      fontSize: 14
                  ),))
          ]
      );
    });
  }

  Widget firstBtWidget(){
    return StatefulBuilder(
        builder: (context, StateSetter setState ){
          return AnimatedSizeAndFade(
            child: !firstBT ? connectBtWidget()
                : Column(
              children: <Widget>[
                Text('CONNECTED TO BLUETOOTH DEVICE',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16
                  ),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 80,
                      child: Image.asset('assets/bluetooth-logo.gif'),
                    ),
                    SizedBox(width: 50,)
                  ],
                ),
                SizedBox(height: 20,),
                Text('Click Continue to Connect Device With Bluetooth Controller',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 15
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                ElevatedButton(onPressed: (){
                  Future.delayed(Duration(milliseconds: 500),() async {
                    await FlutterBluetoothSerial.instance
                        .requestEnable();
                    setState((){
                      firstBT = false;
                    });
                  });

                }, child: Text('CONTINUE')),
                SizedBox(height: MediaQuery.of(context).size.height / 200,)
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return firstBtWidget();
  }
}
