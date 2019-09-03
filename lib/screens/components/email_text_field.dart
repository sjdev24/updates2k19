import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/components/cut_corners_border.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';

class EmailTextField extends StatefulWidget {
  final String hint;
  final Function getData;
  final InputDecoration inputDecoration;

  EmailTextField(
      {@required this.hint, @required this.getData, this.inputDecoration});

  @override
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  bool isValidUser;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: widget.inputDecoration ??
          InputDecoration(
              labelText: widget.hint,
              border: CutCornersBorder(
                  borderSide: BorderSide(color: kColorPrimary), cut: 4.0)),
      validator: (value) {
        if (value == null || value.trim().length == 0)
          return 'This field can\'t be empty';
        if (!kRegExpEmail.hasMatch(value)) return 'Please enter valid email';
        return null;
      },
      onSaved: (value) => widget.getData(value),
    );
  }
}
