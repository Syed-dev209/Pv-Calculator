import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pv_calculator/screens/pv_setup.dart';
import 'package:pv_calculator/screens/installation_calc.dart';
import 'package:pv_calculator/screens/battery_calculator.dart';
import 'package:pv_calculator/screens/aboutUs.dart';

class HomePage extends StatelessWidget {
  List<Widget> rbuttonList=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers:[
           SliverAppBar(
             elevation: 5.0,
             pinned: true,
             floating: false,
             expandedHeight: 250.0,
             flexibleSpace:FlexibleSpaceBar(
               title: Text('PV Calculator'),
               centerTitle: true,
               background: Image.asset('images/bg.jpg',fit: BoxFit.fill,),
             ),
           ),
            SliverFixedExtentList(
              itemExtent: 90.0,
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Rounded_button(
                        colour: Color(0xff347AB6),
                        title: 'PV Setup Calculator',
                        subtitle: 'Home Owners',
                        stitle: true,
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PVSetup();
                          }));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Rounded_button(
                        colour: Color(0xff347AB6),
                        stitle: true,
                        title: 'Installation Calculator',
                        subtitle: 'For Installers',
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Installationcalc();
                          }));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Rounded_button(
                        colour: Color(0xff347AB6),
                        stitle: true,
                        title: 'Battery Calculator',
                        subtitle: 'Off Drid',
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return BatteryCalculator();
                          }));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Rounded_button(
                        colour: Color(0xff347AB6),
                        title: 'About us',
                        stitle: false,
                        subtitle: '',
                        onPressed:(){
                       _showDialog(context);
                        }),
                  ),
                  SizedBox(height: 200,)
                ],
              ),
            )
            
          ]
        ),
      ),
    );
  }
}
void _showDialog(context) {
  showAboutDialog(
      context: context,
      applicationName: 'PV Calculator',
      applicationIcon: Image.asset('images/icon.png',height: 50.0,width: 50.0,),
      applicationVersion: '1.3',
      children: [
        Text('Kindly be advise that using the PV '
            'Calculator you understand that the results '
            'qualified installer as results only provide '
            'calculated estimates.'),
      ]
  );
}
class Rounded_button extends StatefulWidget {
  final Color colour;
  final String title;
  final String subtitle;
  final bool stitle;
  final Function onPressed;

  Rounded_button(
      {this.colour,
      this.title,
      this.subtitle,
      this.stitle,
      @required this.onPressed});

  @override
  _Rounded_buttonState createState() => _Rounded_buttonState();
}

class _Rounded_buttonState extends State<Rounded_button>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _animationController.value;
    return GestureDetector(
        onTapUp: _onTapUp,
        onTapDown: _onTapDown,
        onTap: widget.onPressed,
        child: Transform.scale(
          scale: scale,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 40.0),
            decoration: BoxDecoration(
                color: widget.colour,
                borderRadius: BorderRadius.circular(32.0)),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:AutoSizeText(
                            widget.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 21.0),
                            maxLines: 1,
                            minFontSize: 15.0,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        widget.stitle
                            ? Expanded(
                              child: AutoSizeText(
                                widget.subtitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 17.0),
                                maxLines: 1,
                                minFontSize: 11.0,
                                textAlign: TextAlign.center,
                              ),
                            )
                            : Padding(
                              padding: EdgeInsets.zero,
                            )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
