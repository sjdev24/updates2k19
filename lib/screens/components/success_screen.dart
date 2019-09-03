import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/components/frosted_screen.dart';
import 'package:updates_2k19/settings/flare_paths.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FrostedScreen(
      child: Center(
        child: SizedBox(
          height: 200.0,
          child: FlareActor(
            kFlareSuccessCheck,
            animation: 'success',
            callback: (value) {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
