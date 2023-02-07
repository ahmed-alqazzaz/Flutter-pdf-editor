import 'package:flutter/material.dart';
import 'package:pdf_editor/auth/generics/buttons/enums/button.dart';

class GenericChild extends StatelessWidget {
  const GenericChild({
    super.key,
    required this.button,
  });

  final Button button;

  @override
  Widget build(BuildContext context) {
    if (button == Button.apple ||
        button == Button.facebook ||
        button == Button.google) {
      final ImageProvider<Object> image;

      final String text;

      switch (button) {
        case Button.apple:
          image = const AssetImage("assets/apple_logo.png");

          text = 'Continue with Apple';
          break;
        case Button.facebook:
          image = const AssetImage("assets/facebook_logo.png");

          text = "Continue With Facebook";
          break;
        case Button.google:
          image = const AssetImage("assets/google_logo.png");

          text = "Continue With Gooogle";
          break;
        default:
          // TODO: add failed image && failed text etc..
          image = const AssetImage("assets/apple_logo.png");

          text = 'failed';
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: constraints.maxWidth * 0.15,
                child: Image(
                  image: image,
                  height: 30,
                ),
              ),
              Container(
                width: constraints.maxWidth * 0.7,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: constraints.maxWidth * 0.15),
            ],
          );
        },
      );
    } else {
      final String text;
      final Color textColor;

      switch (button) {
        case Button.login:
          text = "Log in";
          textColor = Colors.white;
          break;
        case Button.nextEnabled:
          text = "Next";
          textColor = Colors.black;
          break;
        case Button.nextDisabled:
          text = "Next";
          textColor = const Color.fromRGBO(167, 167, 167, 100);
          break;
        case Button.createAccount:
          text = "Create account";
          textColor = Colors.black;
          break;
        case Button.register:
          text = "Register";
          textColor = Colors.white;
          break;
        default:
          text = "Failed";
          textColor = Colors.black;
      }
      return Center(
          child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ));
    }
  }
}
