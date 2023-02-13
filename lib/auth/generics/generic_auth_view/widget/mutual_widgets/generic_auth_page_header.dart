import 'package:flutter/material.dart';

import '../../../bloc/enums/auth_type.dart';

typedef OnPressed = void Function();

class GenericAuthPageHeader extends StatelessWidget {
  const GenericAuthPageHeader({
    super.key,
    required this.constraints,
    required this.onBackButtonPressed,
    required this.authType,
  });

  final BoxConstraints constraints;
  final OnPressed onBackButtonPressed;
  final AuthType authType;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          width: constraints.maxWidth * 0.2,
          child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            onPressed: () {
              onBackButtonPressed();
            },
            child: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: constraints.maxWidth * 0.6,
          child: Text(
            authType == AuthType.login ? "Log in" : "Create Account",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * 0.2,
        )
      ],
    );
  }
}
