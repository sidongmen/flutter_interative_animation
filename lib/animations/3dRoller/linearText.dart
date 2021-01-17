import 'package:flutter/material.dart';

class LinearText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        child: Text(
          'ROLLER',
          style: TextStyle(color: Colors.white, fontSize: 110),
        ),
        foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                  Colors.transparent
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 0.2, 0.8])),
      ),
    );
  }
}
