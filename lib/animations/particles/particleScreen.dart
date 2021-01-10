import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'particle.dart';

class ParticleScreen extends StatefulWidget {
  ParticleScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ParticleScreenState createState() => _ParticleScreenState();
}

class _ParticleScreenState extends State<ParticleScreen> {
  final List<Color> colors = [
    Color(0xff4b45ab),
    Color(0xff554fb8),
    Color(0xff605ac7),
    Color(0xff2a91a8),
    Color(0xff2e9ab2),
    Color(0xff32a5bf),
    Color(0xff81b144),
    Color(0xff85b944),
    Color(0xff8fc549),
    Color(0xffe0af27),
    Color(0xffeeba2a),
    Color(0xfffec72e),
    Color(0xffbf342d),
    Color(0xffca3931),
    Color(0xffd7423a)
  ];
  final GlobalKey _boxKey = GlobalKey();
  final Random random = Random();
  Rect boxSize = Rect.zero;
  List<Particle> particles = [];
  final double fps = 1 / 24;
  Timer timer;
  final double gravity = 1.41, dragCof = 0.47, airDensity = 1.1644;

  void onTapDown(BuildContext context, TapDownDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    burstParticles(localOffset.dx, localOffset.dy);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size size = _boxKey.currentContext.size;
      boxSize = Rect.fromLTRB(0, 0, size.width, size.height);
      print(boxSize);
    });

    timer = Timer.periodic(
        Duration(milliseconds: (fps * 1000).floor()), frameBuilder);

    super.initState();
  }

  frameBuilder(dynamic timer) {
    particles.forEach((pt) {
      double dragForceX =
          0.5 * airDensity * pow(pt.velocity.x, 2) * dragCof * pt.area;
      double dragForceY =
          0.5 * airDensity * pow(pt.velocity.y, 2) * dragCof * pt.area;

      dragForceX = dragForceX.isFinite ? 0.0 : dragForceX;
      dragForceY = dragForceY.isFinite ? 0.0 : dragForceY;

      double accX = dragForceX / pt.mass;
      double accY = dragForceY / pt.mass + gravity;

      pt.velocity.x += accX * fps;
      pt.velocity.y += accY * fps;

      pt.postion.x += pt.velocity.x * fps * 100;
      pt.postion.y += pt.velocity.y * fps * 100;
      pt.radius -= 0.1;
      boxCollision(pt);
    });
    setState(() {});
  }

  boxCollision(Particle pt) {
    if (pt.postion.x > boxSize.width - pt.radius) {
      pt.postion.x = boxSize.width - pt.radius;
      pt.velocity.x *= pt.jumpFactor;
    }

    if (pt.postion.x < pt.radius) {
      pt.postion.x = pt.radius;
      pt.velocity.x *= pt.jumpFactor;
    }

    if (pt.postion.y > boxSize.height - pt.radius) {
      pt.postion.y = boxSize.height - pt.radius;
      pt.velocity.y *= pt.jumpFactor;
    }

    if (pt.radius < 0) {
      pt.radius = 0;
    }
  }

  burstParticles(double posX, double posY) {
    if (particles.length > 200) {
      particles.removeRange(0, 75);
    }

    int count = random.nextInt(25).clamp(10, 60);
    for (int x = 0; x < count; x++) {
      Particle p = new Particle();
      p.postion = PVector(posX, posY - 100);
      double randomX = random.nextDouble() * 4.0;
      double randomY = random.nextDouble() * -7.0;
      if (x % 2 == 0) {
        randomX = -1 * randomX;
      }
      p.velocity = PVector(randomX, randomY);
      p.radius = (random.nextDouble() * 10.0).clamp(2.0, 10.0);
      p.color = colors[random.nextInt(colors.length)];
      particles.add(p);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.pop(context)},
          )),
      body: GestureDetector(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          key: _boxKey,
          child: Stack(
            children: [
              ...particles
                  .map((pt) => Positioned(
                      top: pt.postion.y,
                      left: pt.postion.x,
                      child: Container(
                        width: pt.radius * 6,
                        height: pt.radius * 6,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: pt.color),
                      )))
                  .toList(),
            ],
          ),
        ),
        onTapDown: (TapDownDetails details) => onTapDown(context, details),
      ),
    );
  }
}
