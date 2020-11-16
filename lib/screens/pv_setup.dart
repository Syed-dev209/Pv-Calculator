import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pv_calculator/screens/pv_setup_result.dart';
import 'package:pv_calculator/model/calculator.dart';

class PVSetup extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController maxExpectedload=TextEditingController();
  TextEditingController hours=TextEditingController();
  TextEditingController panel=TextEditingController();
  TextEditingController hoursOfSunPerDay=TextEditingController();
  PVCalculatorBrain calc;


  MediaQueryData _queryData;
  @override
  Widget build(BuildContext context) {
    _queryData=MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('PV Setup Calculator'),
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
               fit: BoxFit.fill
             )
           ),
         ),
         Expanded(
           child: SingleChildScrollView(
             child: Container(
               padding: EdgeInsets.symmetric(vertical: 9.0,horizontal: 10.0),
               child: Column(
                 children: [
                   SizedBox(height: 18.0,),
                   Center(
                     child: AutoSizeText(
                       'Data Entry',
                     style: TextStyle(
                       color: Colors.blueAccent,
                       fontSize: 27.0,
                       fontWeight: FontWeight.w900
                     ),
                       maxLines: 1,
                       minFontSize: 15.0,
                     ),
                   ),
                   SizedBox(height: 26.0,),
                   Form(
                     key: _formKey,
                     child: Padding(
                       padding: EdgeInsets.all(1.5),
                       child: Center(
                         child: Container(
                           padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 7.0),
                           color: Colors.white,
                           child: Column(
                             children: [
                               buildTextField('Enter Combined load',maxExpectedload),
                               SizedBox(height: 30.0,),
                               buildTextField('Enter Total Hours / Day Required',hours),
                               SizedBox(height: 30.0,),
                               buildTextField('Enter total Panel Wattage',panel),
                               SizedBox(height: 30.0,),
                               buildTextField('Average Hours of Sunlight',hoursOfSunPerDay),
                             ],
                           ),
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding:  EdgeInsets.symmetric(vertical: 14.0),
                     child: RaisedButton(
                       elevation: 9.0,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(4.0)
                       ),
                       onPressed: (){
                         if(_formKey.currentState.validate())
                           {
                             calc = PVCalculatorBrain();
                             calc.pvSetupCalculator(double.parse(maxExpectedload.text), double.parse(hoursOfSunPerDay.text), double.parse(panel.text), double.parse(hours.text));
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                               return PvSetupResult(calc);
                             }));
                           }

                       },
                       color: Colors.white,
                       child: Text('Calculate',
                       style: TextStyle(
                         fontSize: 14.0
                       ),),
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
      )
    );
  }
}
Widget buildTextField(String labeltext,TextEditingController controller){
  return TextFormField(
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
    ],
    validator: (value){
      if(value==null||value.isEmpty)
        {
          return 'Required Parameter';
        }
      return null;
    },
    controller: controller,
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