import 'package:flutter/material.dart';

class GenericExplanationCard extends StatelessWidget {
  const GenericExplanationCard({
    super.key,
    required this.cardIndex,
    required this.child,
    required this.shape,
  });
  final Widget child;
  final String cardIndex;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape,
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black,
      child: Stack(
        children: [
          child,
          Positioned(
            right: 20,
            bottom: 20,
            child: Text(
              cardIndex,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          )
        ],
      ),
    );
  }
}
