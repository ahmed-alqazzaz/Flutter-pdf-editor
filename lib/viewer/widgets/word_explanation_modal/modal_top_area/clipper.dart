import 'package:flutter/rendering.dart';

class ModalTopMainClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width, size.height * 0.3346000);
    path0.quadraticBezierTo(size.width * 0.9478537, size.height * 0.1318000,
        size.width * 0.8570000, size.height * 0.1469333);
    path0.cubicTo(
        size.width * 0.6557073,
        size.height * 0.1410000,
        size.width * 0.5874146,
        size.height * 0.9885333,
        size.width * 0.4829268,
        size.height * 0.9949333);
    path0.cubicTo(
        size.width * 0.3808049,
        size.height * 0.9924667,
        size.width * 0.3090244,
        size.height * 0.1608667,
        size.width * 0.1194390,
        size.height * 0.1395333);
    path0.quadraticBezierTo(size.width * 0.0408537, size.height * 0.1270667, 0,
        size.height * 0.3246000);
    path0.lineTo(0, 0);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
