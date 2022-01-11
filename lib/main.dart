import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bikecontroller/BluetoothConnect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(),
    ),
    home: MyHomePage(title: 'Bike Controller',),
    debugShowCheckedModeBanner: false,
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  String time = '0:0';
  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);

  @override
  void initState() {
    super.initState();
  }

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      time = newTime.replacing(hour: newTime.hourOfPeriod).toString().substring(10, 15);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0.0,
          backgroundColor: Colors.lightBlue,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  // height: ,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/bg1.png'),
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("DEVICES :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25,
                          ),),
                          Text("Disconnected",
                          style: TextStyle(
                            color: Colors.white
                          ),),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Icon(Icons.restore_from_trash,color: Colors.white,))
                    ],
                  ),
                ),
              ]
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset('assets/engineoff.png',
                              width: 90,),
                            Text('On/Off Mesin',
                            style: TextStyle(
                              fontSize: 10
                            ),)
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset('assets/lock.png',width: 90,),
                            Text('Lock/Guest Mode',
                              style: TextStyle(
                                fontSize: 10
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/clockoff.png',
                                width: 90,),
                              Text('On/Off Timer',
                                style: TextStyle(
                                    fontSize: 10
                                ),)
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('WAKTU : $time',
                                style: TextStyle(
                                    fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                                width: 120,
                                child: ElevatedButton(
                                    onPressed: (){
                                      // _showTime();
                                      Navigator.of(context).push(
                                        showPicker(
                                          context: context,
                                          is24HrFormat: false,
                                          okText: 'SET',
                                          blurredBackground: true,
                                          cancelText: 'CANCEL',
                                          value: _time,
                                          onChange: onTimeChanged,
                                          minuteInterval: MinuteInterval.FIVE,
                                          // Optional onChange to receive value as DateTime
                                          onChangeDateTime: (DateTime dateTime) {
                                            print(dateTime);
                                          },
                                        ),
                                      );
                                    },
                                    child: Text('SET WAKTU',
                                    style: TextStyle(
                                      fontSize: 12
                                    ),)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height / 7,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/rectangle1.png'),
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(35, 25, 35, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("STATUS AKI"),
                            Text("STATUS PERANGKAT"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Image.asset('assets/carbatterypending.png',width: 40,),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('- Aki Baik',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),),
                                      Text('- 10.0 Volt',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Disconnect',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),),
                                    SizedBox(
                                      height: 25,
                                      width: 131,
                                      child: ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              showCupertinoModalBottomSheet(
                                                context: context,
                                                builder: (context) => Padding(
                                                  padding: EdgeInsets.all(30),
                                                  child: Wrap(
                                                    children: <Widget>[
                                                      BluetoothConnect()
                                                    ],
                                                  ),
                                                ),
                                              );
                                              print('disini');
                                            });
                                      },
                                          child: Text('CONNECT',style:
                                            TextStyle(
                                              fontSize: 12,
                                              color: Colors.white
                                            ),)),
                                    )

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ),
        ],
      )
    );
  }
}
