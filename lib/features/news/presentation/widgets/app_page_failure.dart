import 'package:flutter/material.dart';

class AppPageFailureScreen extends StatelessWidget {
  final String error_msg;
  const AppPageFailureScreen({super.key, required this.error_msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_outlined, size: 78,),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(error_msg, style: TextStyle(
              fontSize: 16
            ),textAlign: TextAlign.center,),
          )
        ],
      ),
    );
  }
}
