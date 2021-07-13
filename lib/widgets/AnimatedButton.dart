import 'package:flutter/material.dart';

enum AnimatedButtonState { idle, loading, success, fail }

class AnimatedButton extends StatelessWidget {
  final Map<AnimatedButtonState, Widget> stateButtons;
  final AnimatedButtonState currentState;
  const AnimatedButton({
    Key? key,
    required this.stateButtons,
    required this.currentState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 1000),
      child: Container(
        key: UniqueKey(),
        child: stateButtons[currentState],
      ),
    );
  }
}
