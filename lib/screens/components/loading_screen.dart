import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/components/frosted_screen.dart';

class LoadingScreen extends StatelessWidget {
  static final String ROUTE_NAME = '/LoadingScreen';

  @override
  Widget build(BuildContext context) {
    return FrostedScreen(
      color: Colors.grey[850].withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      ),
    );
  }
}
