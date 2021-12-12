import 'package:flutter/material.dart';

import '../theme/text_theme.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog(this.title, {Key? key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
