import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:pv_calculator/model/calculator.dart';
import 'package:flutter/services.dart';

class BatteryCalculator extends StatefulWidget {
  @override
  _BatteryCalculatorState createState() => _BatteryCalculatorState();
}

class _BatteryCalculatorState extends State<BatteryCalculator> {
  final _formKey = GlobalKey<FormState>();

  PVCalculatorBrain calc = PVCalculatorBrain();
  static const List<double> _temprature = [
    1.1,
    1.04,
    1.11,
    1.19,
    1.3,
    1.4,
    1.59
  ];

  static const List<double> _volt = [12, 24, 48];
  double selectedTemp=_temprature.first;
  double selectedVolt=_volt.first;
  TextEditingController wattHoursPerDay = TextEditingController();
  TextEditingController daysOfBackup = TextEditingController();

  showTempPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedTemp = _temprature[value];
                print(selectedTemp);
              });
            },
            itemExtent: 38.0,
            children: [
              for (var i in _temprature)
                DropdownMenuItem(
                  value: i,
                  child: Text(i == 1.1
                      ? '80F (27C)'
                      : i == 1.04
                          ? '70F (21c)'
                          : i == 1.11
                              ? '60F (16C)'
                              : i == 1.19
                                  ? '50F (10C)'
                                  : i == 1.3
                                      ? '40F (4C)'
                                      : i == 1.4
                                          ? '30F (-1C)'
                                          : '20F (-7C)'),
                )
            ],
          );
        });
  }

  showVoltPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedTemp = _volt[value];
                print(selectedTemp);
              });
            },
            itemExtent: 32.0,
            children: [
              for (var i in _volt)
                DropdownMenuItem(
                  value: i,
                  child: Text('$i'),
                )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Battery Calculator'),
          centerTitle: true,
          backgroundColor: Color(0xff347AB6),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/pv_setup.jpg'),
                        fit: BoxFit.fill)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 9.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 17.0,
                        ),
                        AutoSizeText(
                          'Your Daily Energy Usage',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          minFontSize: 15.0,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.all(1.5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    buildTextField(
                                        'Watt hours needed per day',
                                        'This value is usually printed on your electric bill.'
                                            ' If you don\'t have a bill or don\'t know your consumption, please use our PV CALCULATOR '
                                            'to determine this value.',
                                        wattHoursPerDay),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                buildTextField(
                                    'How many days should your system run without Sun?',
                                    'How many days of backup power do you want in case of cloudy/ rainy days?'
                                        '(When you solar panels will produce little energy)',
                                    daysOfBackup),
                                SizedBox(
                                  height: 10.0,
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                AutoSizeText(
                                  'What is the lowest temperature your batter bank will experience?',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0,
                                  ),
                                  minFontSize: 15.0,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Platform.isAndroid
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        elevation: 5.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 3.0),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            hint: Text(
                                                'Select Lowest Temperature'),
                                            value: selectedTemp,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedTemp = newValue;
                                              });
                                            },
                                            items: [
                                              for (var i in _temprature)
                                                DropdownMenuItem(
                                                  value: i,
                                                  child: Text(i == 1.1
                                                      ? '80F (27C)'
                                                      : i == 1.04
                                                          ? '70F (21c)'
                                                          : i == 1.11
                                                              ? '60F (16C)'
                                                              : i == 1.19
                                                                  ? '50F (10C)'
                                                                  : i == 1.3
                                                                      ? '40F (4C)'
                                                                      : i == 1.4
                                                                          ? '30F (-1C)'
                                                                          : '20F (-7C)'),
                                                )
                                            ],
                                          ),
                                        ),
                                      )
                                    : RaisedButton(
                                        elevation: 7.0,
                                        color: Colors.white,
                                        textColor: Colors.blueAccent,
                                        child:
                                            Text('Select Lowest Temperature'),
                                        onPressed: () {
                                          showTempPicker(context);
                                        },
                                      ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                // Adjust the Effective capacity of your battery due to low temperatures'
                                SizedBox(
                                  height: 20.0,
                                ),
                                AutoSizeText(
                                  'Select the Battery bank voltage',
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0),
                                  minFontSize: 15.0,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                                Platform.isAndroid
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.blueGrey,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        elevation: 5.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0, vertical: 3.0),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            hint: Text(
                                                'Select battery bank voltage'),
                                            value: selectedVolt,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedVolt = newValue;
                                              });
                                            },
                                            items: [
                                              for (var i in _volt)
                                                DropdownMenuItem(
                                                  value: i,
                                                  child: Text('$i'),
                                                )
                                            ],
                                          ),
                                        ),
                                      )
                                    : RaisedButton(
                                        elevation: 7.0,
                                        color: Colors.white,
                                        textColor: Colors.blueAccent,
                                        child:
                                            Text('Select Battery bank voltage'),
                                        onPressed: () {
                                          showVoltPicker(context);
                                        },
                                      )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          child: RaisedButton(
                            elevation: 9.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                calc.offGridCalculator(
                                    double.parse(wattHoursPerDay.text),
                                    double.parse(daysOfBackup.text),
                                    selectedTemp,
                                   selectedVolt);
                                setState(() {
                                  showAlertDialogBox(
                                      context,
                                      calc.cap.toString(),
                                      calc.wattHoursPerDay.ceil().toString(),
                                      calc.perString.toString());
                                });
                              }
                            },
                            color: Colors.white,
                            child: Text(
                              'Calculate',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            textColor: Color(0xff347AB6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

showAlertDialogBox(context, String bb_cap, String ampHours, String perString) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'Results',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,

                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              content: Container(
                height: 220.0,
                width: 200.0,
                child: Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Battery bank Capacity :',
                        children: [
                          TextSpan(
                              text: '$ampHours watt hours',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Battery bank Capacity :',
                        children: [
                          TextSpan(
                              text: '$bb_cap amp hours',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: '3 String configuration ',
                        children: [
                          TextSpan(
                              text: '$perString amp hours',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                              children: [TextSpan(text: 'per string')]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    AutoSizeText(
                      'Note: All calculations assume only a 50% discharge to your batteries to optimize battery life',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      minFontSize: 10.0,
                    )
                  ],
                ),
              ),
            );
          });
}

Widget buildTextField(
    String labeltext, String message, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
    ],
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Required Parameter';
      }
      return null;
    },
    decoration: InputDecoration(
      icon: Tooltip(
          message: message,
          child: Icon(
            Icons.info_outline,
            color: Colors.redAccent,
          )),
      labelText: labeltext,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
        borderSide: BorderSide(
          color: Colors.blueAccent,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Colors.blueGrey,
          width: 2.0,
        ),
      ),
    ),
  );
}
