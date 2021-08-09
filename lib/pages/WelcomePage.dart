import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:sportify_app/providers/Auth.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  final gradientColors = [Color(0XFF000033), Color(0XFF1F1F60)];

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        value: 0.0,
        duration: Duration(seconds: 25),
        upperBound: 1,
        lowerBound: -1)
      ..repeat();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (ctx, _) => ClipPath(
                  clipper: DrawClip(_controller.value),
                  child: Container(
                    height: size.height * 0.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: gradientColors)),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  )),
              Text(
                'Join now to the growing community of Sportify!',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Container(
            width: size.width * 0.8,
            alignment: Alignment.center,
            child: Text(
              'For a Demo version we allow to sign in only with google account',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: size.height * .06,
          ),
          Container(
            child: InkWell(
              onTap: () {
                Provider.of<Auth>(context, listen: false).googleLogin();
              },
              child: Ink(
                color: Color(0XFF1F1F60),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.android,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        'SignIn With Google',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;
  DrawClip(this.move);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * slice);
    double yCenter = size.height * 0.8 + 69 * math.cos(move * slice);

    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
