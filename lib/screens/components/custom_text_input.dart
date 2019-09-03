import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/components/accent_color_override.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';

class CustomTextInput extends StatelessWidget {
  final String label;
  final Function validator;
  final Function onSaved;
  final TextInputType inputType;

  CustomTextInput({
    this.label,
    this.validator,
    this.onSaved,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 16.0,
      ),
      child: AccentColorOverride(
        color: kColorPrimaryLight,
        child: TextFormField(
          keyboardAppearance: Brightness.dark,
          keyboardType: inputType,
          decoration: kCutsomTextInputDecoration(label),
          validator: validator,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
