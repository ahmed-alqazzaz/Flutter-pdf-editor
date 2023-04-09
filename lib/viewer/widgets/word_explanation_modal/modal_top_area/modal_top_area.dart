import 'package:flutter/material.dart';
import 'clipper.dart';

class ModalTopArea extends StatelessWidget {
  const ModalTopArea({super.key, required this.word, required this.pos});
  static const double height = 100;

  final String word;
  final String pos;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ModalTopMainClipper(),
      child: Container(
        color: Colors.deepPurple,
        height: height,
        width: 411,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TODO:  this needs to be cropped
              SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    word,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  pos,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
