import 'package:flutter/material.dart';

class ErrorMessage extends StatefulWidget {
  const ErrorMessage({super.key, required this.text});

  final String text;

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage>
    with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // add animation listener
    _animationController.addListener(() {
      setState(() {});
    });

    // kick off the opacity animation
    _animationController.forward();

    // The opacity will be at its maximum for 2 seconds. Afterwards, the animation will reverse
    Future.delayed(const Duration(milliseconds: 2300)).then((value) {
      _animationController.reverse();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: _animation.value,
          child: Align(
            alignment: const Alignment(0, 0.9),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 0.03 * height,
                  maxHeight: height * 0.1,
                  maxWidth: 350,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color.fromRGBO(239, 239, 239, 100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
