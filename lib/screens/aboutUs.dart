import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PV Calculator'),
        centerTitle: true,
        backgroundColor: Color(0xff347AB6),
      ),
     body: SafeArea(
       child: Container(
         padding: EdgeInsets.symmetric(vertical:20.0,horizontal: 20.0),
         decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage('images/background.png'),
             fit: BoxFit.cover
           )
         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
               padding: EdgeInsets.symmetric(horizontal: 2.0,vertical:2.0),
               decoration: BoxDecoration(
                 color: Color(0xff347AB6),
                 borderRadius: BorderRadius.all(Radius.circular(4.0))
               ),
               child: Column(
                 children: [
                   SizedBox(height: 20.0,),
                   Text('About Us',
                     style: TextStyle(
                         color: Colors.white,
                         fontSize: 26.0,
                         fontWeight: FontWeight.bold
                     ),),
                   SizedBox(height: 20.0,),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 7.0,vertical: 7.0),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4.0),bottomRight: Radius.circular(4.0))
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text('Version 1.3',
                             style: TextStyle(
                               fontWeight: FontWeight.bold
                             ),
                             ),
                             SizedBox(height: 10.0,),
                             Text(''),
                             SizedBox(height: 3.0,),
                             Text('If you have any improvement idea for us, we '
                                 'can be reached at:'),
                             SizedBox(height: 5.0,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.email,
                                 color: Colors.redAccent,
                                 ),
                                 SizedBox(width: 5.0,),
                                 Text('asoetan@gmail.com',
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold
                                 ),
                                 )
                               ],
                             )
                           ],
                         )
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
     ),
    );
  }
}
