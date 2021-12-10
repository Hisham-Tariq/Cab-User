import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTimeField extends StatelessWidget {
  const CurrentTimeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    return Expanded(
      child: TextFormField(
        enabled: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 30.0),
        ),
        initialValue: DateFormat.yMMMMEEEEd().add_jm().format(currentTime),
        // initialValue: 'Sun, 18-July at 12:44 PM',
      ),
    );
  }
}
