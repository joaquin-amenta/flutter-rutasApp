import 'package:flutter/material.dart';
import 'package:rutasapp/custom_markers/custom_markers.dart';



class TestMarkerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            painter: MarkerInicioPainter(230),
            // painter: MarkerDestinoPainter(
            //   'Aqui esta mi casa en Mar del Plata, asldkj, aslkdj',
            //   250904
            // ),
          ),
        ),
     ),
   );
  }
}