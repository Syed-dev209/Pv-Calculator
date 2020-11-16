import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:pv_calculator/screens/homePage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:pv_calculator/model/calculator.dart';

class PvSetupResult extends StatefulWidget {
  PVCalculatorBrain calc;

  PvSetupResult(this.calc);

  @override
  _PvSetupResult createState() => _PvSetupResult();
}

class _PvSetupResult extends State<PvSetupResult> {
  MediaQueryData _queryData;
  static const List<int> _locations = [12, 24, 36, 48];
  int selectedValue = _locations.first;

  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);

    showPicker() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return CupertinoPicker(
                backgroundColor: Colors.white,
                onSelectedItemChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    print(selectedValue);
                    widget.calc.calculateBatterySizing(_locations[selectedValue]);
                  });
                },
                itemExtent: 32.0,
                children: [
                  for (int i in _locations)
                    DropdownMenuItem(
                      value: i,
                      child: Text('$i'),
                    )
                ]);
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Report'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
            child: Column(
              children: [
                customCard(
                    'Load daily Watt Hours',
                    widget.calc.loadDailyWattHours.toStringAsFixed(2),
                    _queryData.size.width),
                SizedBox(
                  height: 7.0,
                ),
                customCard(
                    'Load Monthly Watt Hours',
                    widget.calc.loadMonthlyWattHours.toStringAsFixed(2),
                    _queryData.size.width),
                SizedBox(
                  height: 7.0,
                ),
                customCard(
                    'Solar Daily Watt Hours',
                    widget.calc.solarDailyWattHours.toStringAsFixed(2),
                    _queryData.size.width),
                SizedBox(
                  height: 7.0,
                ),
                customCard(
                    'Solar Monthly Watt Hours',
                    widget.calc.solarMonthlyWattHours.toStringAsFixed(2),
                    _queryData.size.width),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: Text(
                  'Battery Sizing',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                )),
                Container(
                    width: _queryData.size.width,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Platform.isAndroid
                                ? Card(
                                    elevation: 5.0,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: Text('Cable Type'),
                                        value: selectedValue,
                                        onChanged: (newValue) {
                                          print('$newValue');
                                          setState(() {
                                            selectedValue = newValue;
                                            widget.calc.calculateBatterySizing(
                                                newValue);
                                          });
                                        },
                                        items: [
                                          for (int i in _locations)
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
                                    child: Text('Cable Type'),
                                    onPressed: () {
                                      showPicker();
                                    }),
                            customCard(
                                'Required battery Size',
                                widget.calc.batteryValue.toStringAsFixed(2),
                                _queryData.size.width - 50),
                          ],
                        ),
                      ),
                    )),
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: widget.calc.status
                    )
                ),
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
                          TextStyle(fontSize: 17.0, color: Colors.blueAccent),
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
