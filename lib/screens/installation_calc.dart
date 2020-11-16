import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:pv_calculator/screens/instalation_calc_result.dart';
import 'package:pv_calculator/model/calculator.dart';

class Installationcalc extends StatefulWidget {
   static const List<int> _locations = [1, 2];

  @override
  _InstallationcalcState createState() => _InstallationcalcState();
}

class _InstallationcalcState extends State<Installationcalc> {
  final _formKey = GlobalKey<FormState>();
  int selectedValue= Installationcalc._locations.first;
  TextEditingController voc = TextEditingController();
  TextEditingController isc = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController quantity = TextEditingController();

  int connectionType = 0;
  PVCalculatorBrain calc = PVCalculatorBrain();

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
              backgroundColor: Colors.white,
              onSelectedItemChanged: (value) {
                setState(() {
                  value++;
                  selectedValue = value;
                  print(selectedValue);
                });
              },
              itemExtent: 32.0,
              children: [
                for (int i in Installationcalc
                    ._locations)
                  DropdownMenuItem(
                    value: i,
                    child: Text(i == 1
                        ? 'Parallel'
                        : 'Series'),
                  )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Installation Calculator'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      Center(
                        child: AutoSizeText(
                          'Solar Panel Parameters',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold),
                          minFontSize: 15.0,
                          maxLines: 1,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(1.5),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 7.0),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Text('VOC-(Volts)'),
                                buildTextField('Open Circuit Voltage', voc),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text('ISC-(Amps)'),
                                buildTextField('Short Circuit Current', isc),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text('Rating-(Watts)'),
                                buildTextField('Max Panel Power', rating),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text('Quantity-(Total panel to be used)'),
                                buildTextField(
                                    'Total Panel to be used', quantity),
                                SizedBox(
                                  height: 7.0,
                                ),
                                AutoSizeText('Connection type'),
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
                                      elevation: 4,
                                      hint: Text(selectedValue==1?'Parallel':'Series'),
                                      value: selectedValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          print(newValue);
                                          selectedValue = newValue;
                                        });
                                      },
                                      items: [
                                        for (int i in
                                            Installationcalc._locations)
                                DropdownMenuItem(
                                  value: i,
                                  child: Text(i == 1
                                      ? 'Parallel'
                                      : 'Series'),
                                )
                              ],
                            ),
                          ),
                                )
                                    : RaisedButton(
                                  elevation: 7.0,
                                  color: Colors.white,
                                  child: Text('Connection Type'),
                                  textColor: Colors.blue,
                                  onPressed: () {
                                    showPicker();
                                  },
                                ),
                              ],
                            ),
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
                            if (_formKey.currentState.validate() &&
                                selectedValue != null) {
                              calc.installationCalculator(
                                  double.parse(voc.text),
                                  double.parse(isc.text),
                                  double.parse(rating.text),
                                  double.parse(quantity.text),
                                  selectedValue.toDouble());
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return InstallationResult(calc);
                                  }));
                            }
                          },
                          color: Colors.white,
                          child: Text(
                            'Proceed',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          textColor: Color(0xff347AB6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
