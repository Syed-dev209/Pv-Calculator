import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:pv_calculator/screens/homePage.dart';
import 'package:pv_calculator/model/calculator.dart';

class InstallationResult extends StatefulWidget {
  PVCalculatorBrain calc;
  InstallationResult(this.calc);
  @override
  _InstallationResultState createState() => _InstallationResultState();
}

class _InstallationResultState extends State<InstallationResult> {
  TextEditingController cableLength = TextEditingController();
  TextEditingController length = TextEditingController();
  MediaQueryData _queryData;
  bool show = false;

  static const List<int> _locations = [1, 2];
  int selectedValue;

  showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              selectedValue = value;
              setState(() {
                widget.calc.cableCrossSection(double.parse(cableLength.text),
                    double.parse(length.text), selectedValue);
                show = true;
              });
            },
            itemExtent: 32.0,
            children: [
              for (int i in _locations)
                DropdownMenuItem(
                  value: i,
                  child: Text(i == 1 ? 'Copper' : 'Aluminium'),
                )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Report'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              children: [
                Center(
                    child: AutoSizeText(
                  'Solar Panel Parameters',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 15.0,
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customCard(
                        'Power (Watts)',
                        widget.calc.power.toStringAsFixed(2),
                        _queryData.size.width),
                    customCard(
                        'Maximum (Volts)',
                        widget.calc.maxVoltage.toStringAsFixed(2),
                        _queryData.size.width),
                    customCard(
                        'Maximum Current (Amps)',
                        widget.calc.maxCurrent.toStringAsFixed(2),
                        _queryData.size.width),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Center(
                    child: AutoSizeText(
                  'Charge Controller',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 15.0,
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        customCard(
                            'Maximum Voltage (volts)',
                            widget.calc.minVoltage.toStringAsFixed(2),
                            _queryData.size.width),
                        customCard(
                            'Minimum Current (amps)',
                            widget.calc.minCurrent.toStringAsFixed(2),
                            _queryData.size.width),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: AutoSizeText(
                  'Cable Cross Section',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 15.0,
                )),
                Card(
                  elevation: 7.0,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text('Cable length(m)'),
                            buildTextField(
                                'from Solar panel to Inverter', length),
                            SizedBox(
                              height: 13.0,
                            ),
                            Text('Cross Section(mm2)'),
                            buildTextField('Meter Square', cableLength),
                            SizedBox(
                              height: 13.0,
                            ),
                            Platform.isAndroid
                                ? Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.blueGrey, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(7.0)),
                                    elevation: 5.0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0, vertical: 3.0),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: Text('Cable Type'),
                                        value: selectedValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedValue = newValue;
                                          });
                                          print(newValue);
                                          setState(() {
                                            widget.calc.cableCrossSection(
                                                double.parse(cableLength.text),
                                                double.parse(length.text),
                                                selectedValue);
                                            show = true;
                                          });
                                        },
                                        items: [
                                          for (int i in _locations)
                                            DropdownMenuItem(
                                              value: i,
                                              child: Text(i == 1
                                                  ? 'Copper'
                                                  : 'Aluminium'),
                                            )
                                        ],
                                      ),
                                    ),
                                  )
                                : RaisedButton(
                                    elevation: 7.0,
                                    color: Colors.white,
                                    textColor: Colors.blueAccent,
                                    child: Text('Cable Type'),
                                    onPressed: () {
                                      showPicker(context);
                                    },
                                  ),
                            SizedBox(
                              height: 30.0,
                              child: Divider(
                                color: Colors.blueGrey,
                              ),
                            ),
                            customCard(
                                'PV Losses (Watts)',
                                widget.calc.pvLosses.toStringAsFixed(2),
                                _queryData.size.width),
                            show
                                ? AutoSizeText(
                                    'Acceptable Result must be below 22.6 watt',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    minFontSize: 10.0,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  )
                                : Container(),
                            customCard(
                                'PV Losses (Percent)',
                                widget.calc.pvPercent.toStringAsFixed(2),
                                _queryData.size.width),
                            show
                                ? AutoSizeText(
                                    'Acceptable Result must be below 1%',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    minFontSize: 10.0,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: AutoSizeText(
                  'Protective Devices',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                  minFontSize: 15.0,
                  maxLines: 1,
                )),
                customCard(
                    'Voltage rating(volts) Must be equal to or greater than',
                    widget.calc.voltageRating.toString(),
                    _queryData.size.width),

                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: Text(
                  'Fuse-Links Rated Current',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                )),
                customCard('Fuse Current (Amps)',
                    widget.calc.fuseCurrent.toString(), _queryData.size.width),

                //button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: RaisedButton(
                    elevation: 5.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Text(
                      'Back to Main Menu',
                      style:
                          TextStyle(color: Colors.blueAccent, fontSize: 17.0),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(String labeltext, TextEditingController controller) {
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
      labelText: labeltext,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
        borderSide: BorderSide(
          color: Colors.blue,
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

Widget customCard(String title, String value, double width) {
  return Container(
    width: width,
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400),
              maxLines: 2,
              minFontSize: 18.0,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            AutoSizeText(
              value,
              style: TextStyle(color: Colors.lightBlue, fontSize: 23.0),
              maxLines: 1,
              minFontSize: 17.0,
            ),
            SizedBox(
              width: 85.0,
              child: Divider(
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
