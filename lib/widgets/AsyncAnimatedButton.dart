import 'package:async_button_builder/async_button_builder.dart';
import 'package:driving_app_its/customization/customization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AsyncButtonState { idle, loading, success, fail, orElse }

class AsyncAnimatedButton extends StatelessWidget {
  final ButtonState buttonState;
  final Map<AsyncButtonState, String> stateTexts;
  final Map<AsyncButtonState, Color> stateColors;
  final Map<AsyncButtonState, IconData> stateIcons;
  final Future<void> Function()? onPressed;

  const AsyncAnimatedButton({
    Key? key,
    this.buttonState = const ButtonState.idle(),
    required this.stateTexts,
    required this.stateColors,
    required this.stateIcons,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      duration: Duration(milliseconds: 5000),
      animateSize: true,
      buttonState: buttonState,
      child: Container(),
      loadingWidget: Container(),
      successWidget: Container(),
      onPressed: onPressed,
      loadingSwitchInCurve: Curves.bounceInOut,
      loadingTransitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1.0),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
      builder: (context, childs, callback, buttonstate) {
        Color colors;
        Widget child;
        ShapeBorder buttonShape;
        if (buttonState == ButtonState.idle()) {
          colors = (stateColors[AsyncButtonState.idle] ??
              stateColors[AsyncButtonState.orElse]) as Color;
          buttonShape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          );
          child = _AsyncButtonGenerator(
            stateTexts[AsyncButtonState.idle],
            Icons.arrow_right,
          );
        } else if (buttonState == ButtonState.success()) {
          colors = colors = (stateColors[AsyncButtonState.success] ??
              stateColors[AsyncButtonState.orElse]) as Color;
          buttonShape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          );
          child = _AsyncButtonGenerator(
            stateTexts[AsyncButtonState.success],
            Icons.check_circle_outline_rounded,
          );
        } else if (buttonState == ButtonState.error()) {
          colors = colors = (stateColors[AsyncButtonState.fail] ??
              stateColors[AsyncButtonState.orElse]) as Color;
          buttonShape = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          );
          child = _AsyncButtonGenerator(
            stateTexts[AsyncButtonState.fail],
            Icons.cancel_outlined,
          );
        } else {
          colors = (stateColors[AsyncButtonState.loading] ??
              stateColors[AsyncButtonState.orElse]) as Color;
          buttonShape = StadiumBorder();
          child = Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            ),
          );
        }

        return Material(
          color: colors,
          // This prevents the loading indicator showing below the
          // button
          clipBehavior: Clip.hardEdge,
          shape: buttonShape,
          child: InkWell(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: child,
            ),
            onTap: callback,
          ),
        );
      },
    );
  }

  _AsyncButtonGenerator(text, icon) {
    return Container(
      key: ValueKey('$text ${icon.toString()}'),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyle.button,
          ),
        ],
      ),
    );
  }
}
