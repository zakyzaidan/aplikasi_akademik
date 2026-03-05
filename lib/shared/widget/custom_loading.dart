import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final String? message;
  final Color color;

  const CustomLoading({Key? key, this.message, this.color = Colors.blue})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
