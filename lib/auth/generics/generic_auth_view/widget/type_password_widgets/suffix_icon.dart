import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../bloc/auth_event.dart';
import '../../../../bloc/auth_state.dart';

class SuffixIcon extends StatefulWidget {
  const SuffixIcon({super.key, required this.timerStreamController});

  final StreamController<Timer?> timerStreamController;

  @override
  State<SuffixIcon> createState() => _SuffixIconState();
}

class _SuffixIconState extends State<SuffixIcon> {
  late Timer? timer;
  @override
  void initState() {
    final stream = widget.timerStreamController.stream;
    stream.listen((event) {
      timer = event;
    });
    widget.timerStreamController.sink.add(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthBloc>().state as AuthStateTypingPassword;
    return Shimmer.fromColors(
      enabled: state.shouldVisibilityIconShimmer,
      baseColor: Colors.black,

      // in case there is residual shimmer left when shimmer is disabled, turn it's color to black
      highlightColor:
          state.shouldVisibilityIconShimmer ? Colors.white : Colors.black,
      child: GestureDetector(
        onTapUp: (details) {
          //cancel the disabling of the shimmer if exists
          timer?.cancel();
          widget.timerStreamController.sink.add(timer);
          context.read<AuthBloc>().add(
                AuthEventTypePassword(
                  email: state.email,
                  shouldVisibilityIconShimmer: true,
                  isTextObscure: !state.isTextObscure,
                  textFieldBorderColor: state.textFieldBorderColor,
                  authPage: state.authPage,
                  isFieldValid: state.isFieldValid,
                  authType: state.authType,
                ),
              );

          //disable the shimmer after one 3 seconds
          timer = Timer(
            const Duration(milliseconds: 3000),
            () {
              context.read<AuthBloc>().add(
                    AuthEventTypePassword(
                      email: state.email,
                      shouldVisibilityIconShimmer: false,
                      isTextObscure: state.isTextObscure,
                      textFieldBorderColor: state.textFieldBorderColor,
                      authPage: state.authPage,
                      isFieldValid: state.isFieldValid,
                      authType: state.authType,
                    ),
                  );
            },
          );
          widget.timerStreamController.sink.add(timer);
        },
        child: Container(
          alignment: const Alignment(1, 0.5),
          width: 1,
          child: Icon(
            size: 20,
            state.isTextObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
