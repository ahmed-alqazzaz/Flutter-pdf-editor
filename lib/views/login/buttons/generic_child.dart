import 'package:flutter/material.dart';
import 'package:pdf_editor/views/login/enums/button.dart';

class GenericChild extends StatelessWidget {
  final Button button;
  const GenericChild({
    super.key,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    if (button == Button.apple ||
        button == Button.facebook ||
        button == Button.google) {
      final ImageProvider<Object> image;
      final EdgeInsetsGeometry padding;
      final String text;
      print(button);
      switch (button) {
        case Button.apple:
          image = const AssetImage("assets/apple_logo.png");
          padding = const EdgeInsets.only(left: 74.0);
          text = 'Continue with Apple';
          break;
        case Button.facebook:
          image = const AssetImage("assets/facebook_logo.png");
          padding = const EdgeInsets.only(left: 60.0);
          text = "Continue With Facebook";
          break;
        case Button.google:
          image = const AssetImage("assets/google_logo.png");
          padding = const EdgeInsets.only(left: 69.0);
          text = "Continue With Gooogle";
          break;
        default:
          // TODO: add failed image && failed text etc..
          image = const AssetImage("assets/apple_logo.png");
          padding = const EdgeInsets.only(left: 0);
          text = 'failed';
      }
      return Row(
        children: [
          Image(
            image: image,
            height: 30,
          ),
          Padding(
            padding: padding,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      final String text;
      final Color textColor;

      switch (button) {
        case Button.login:
          text = "Log in";
          textColor = Colors.white;
          break;
        case Button.createAccount:
          text = "Create account";
          textColor = Colors.black;
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
