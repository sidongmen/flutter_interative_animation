import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'linearText.dart';

class Three3DRollerScreen extends StatefulWidget {
  String title;
  Three3DRollerScreen({Key key, this.title}) : super(key: key);
  @override
  _Three3DRollerScreenState createState() => _Three3DRollerScreenState();
}

class _Three3DRollerScreenState extends State<Three3DRollerScreen>
// with SingleTickerProviderStateMixin
{
  // AnimationController _animationController;
  bool isOnLeft(double rotation) => math.cos(rotation) > 0;
  bool isDown = false;
  double moveX = 0;
  double offsetX = 0;

  final numberOfTexts = 20;
  final StreamController<double> _streamController = StreamController<double>();

  onDown(double e) {
    this.isDown = true;
    this.moveX = 0;
    this.offsetX = e;
  }

  onMove(double e) {
    if (this.isDown) {
      this.moveX = e - this.offsetX;
      this.offsetX = e;
    }
  }

  onUp(double e) {
    this.isDown = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    // _animationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));

    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('3D Roller'),
        ),
        body: Stack(
          children: [
            SizedBox.expand(
                child: StreamBuilder<double>(
              stream: _streamController.stream,
              initialData: 0.0,
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                return Stack(
                  alignment: Alignment.center,
                  children: List.generate(numberOfTexts, (index) {
                    final motionValue = snapshot.data * 0.01;
                    double rotation = 2 * math.pi * index / numberOfTexts +
                        math.pi / 2 +
                        motionValue;
                    if (isOnLeft(rotation)) {
                      rotation = -rotation +
                          2 * motionValue -
                          math.pi * 2 / numberOfTexts;
                    }
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(rotation)
                        ..translate(-120.0),
                      alignment: Alignment.center,
                      child: LinearText(),
                    );
                  }),
                );
              },
            )),
            SizedBox.expand(child: GestureDetector(onPanUpdate: (details) {
              double e = details.delta.dx;
              if (e > 0) {
                this.onDown(e);
              } else {
                this.onUp(e);
              }
              this.onMove(e);
              print(e);
              _streamController.sink.add(e);
            })),
          ],
        ));
  }
}
